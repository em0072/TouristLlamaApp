//
//  OnboardViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation
import AuthenticationServices
import Dependencies

@MainActor
class OnboardingViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var isTermsAndConditionsShown: Bool = false
    
    lazy var features: [FeatureItem] = {
        return OnboardingFeaturesBuilder().build()
    }()
    
    func handleSignInAuthorisationResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            Task {
                guard let credentials = auth.credential as? ASAuthorizationAppleIDCredential,
                      let identityToken = credentials.identityToken,
                      let tokenString = String(data: identityToken, encoding: .utf8) else {
                    self.error = CustomError()
                    return
                }
                self.loadingState = .loading
                do {
                    try await userAPI.login(token: tokenString)
                    
                    // Update Name if possible
                    let givenName = credentials.fullName?.givenName
                    let familyName = credentials.fullName?.familyName
                    var fullName: String = ""
                    if let givenName {
                        fullName += givenName
                    }
                    if let familyName {
                        if !fullName.isEmpty {
                            fullName += " "
                        }
                        fullName += familyName
                    }
                    
                    var properties = [User.Property: Any]()
                    if !fullName.isEmpty {
                        properties[.name] = fullName
                    }
                    if let email = credentials.email,
                       let generatedUsername = generatedUserName(from: email) {
                        properties[.username] = generatedUsername
                    }
                    
                    if !properties.isEmpty {
                        try await userAPI.updateUserProperty(properties)
                    }
                } catch {
                    self.error = error
                }
                self.loadingState = .none
            }
        case .failure(let error):
            self.error = error
        }
    }
    
    func showTermsAndConditions() {
        isTermsAndConditionsShown = true
    }
    
    func generatedUserName(from email: String) -> String? {
        guard let emailMainPart = email.components(separatedBy: "@").first else {
            return nil
        }
        let firstPart: String
        if emailMainPart.count > 6 {
            firstPart = "\(emailMainPart.dropFirst(5))"
        } else {
            firstPart = emailMainPart
        }
        let calendar = Calendar.current
        let date = Date()
        let day = calendar.component(.day, from: date)
        let week = calendar.component(.weekOfYear, from: date)
        let second = calendar.component(.second, from: date)
        return firstPart + "\(week)\(day)\(second)"
    }
}
