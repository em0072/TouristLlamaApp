//
//  LogInViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import Foundation
import Dependencies

@MainActor
class LogInViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordRecoveryShown = false

        
    func login() {
        Task {
            do {
                self.loadingState = .loading
                try await userAPI.login(email: email, password: password)
            } catch {
                self.error = error
            }
            self.loadingState = .none
        }
    }
    
    func showPasswordRecovery() {
        isPasswordRecoveryShown = true
    }
    
    func recoverPassword() {
        Task {
            do {
                self.loadingState = .loading
                try await userAPI.recoverPassword(email: email)
                isPasswordRecoveryShown = false
            } catch {
                self.error = error
            }
            self.loadingState = .none
        }

    }
    
    var isLoginButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
}
