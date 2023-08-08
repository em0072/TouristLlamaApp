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
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEmailConfirmationShown = false
    @Published var isLoginShown = false
    
    var isRegisterButtonDisabled: Bool {
        name.isEmpty || password.isEmpty || email.isEmpty
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
                _ = try await userAPI.registerUser(name: name, email: email, password: password)
                isEmailConfirmationShown = true
            } catch {
                self.error = error
            }
            loadingState = .none
        }
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
