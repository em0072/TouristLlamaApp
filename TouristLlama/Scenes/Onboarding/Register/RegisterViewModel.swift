//
//  RegisterViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation
import Dependencies

@MainActor
class RegisterViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    enum SheetType: Identifiable {
        var id: Self { return self }
        
        case emailConfirmation
        case termsAndConditions
    }
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var termsAccepted: Bool = false
    @Published var isLoginShown = false
    @Published var sheetType: SheetType?

    var isRegisterButtonDisabled: Bool {
        name.isEmpty || password.isEmpty || email.isEmpty || !termsAccepted
    }
    
    func showLoginView() {
        isLoginShown = true
    }
    
    func registerNewUser() {
        guard email.isValidEmail else {
            self.error = CustomError(text: String.Error.checkEmail)
            return
        }
        Task {
            do {
                loadingState = .loading
                try await userAPI.registerUser(name: name, email: email, password: password)
                sheetType = .emailConfirmation
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func showTermsAndConditions() {
        sheetType = .termsAndConditions
    }
    
    func resendEmailConfirmation() {
        Task {
            do {
                loadingState = .loading
                _ = try await userAPI.resendConfirmationEmail(email: email)
                loadingState = .success
            } catch {
                loadingState = .error(error)
            }
        }
    }
}
