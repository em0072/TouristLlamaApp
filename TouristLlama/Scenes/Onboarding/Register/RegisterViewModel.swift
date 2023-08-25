//
//  RegisterViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI
import Dependencies

class RegisterViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    enum SheetType: Identifiable {
        var id: Self { return self }
        
        case emailConfirmation
        case termsAndConditions
    }
    
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var termsAccepted: Bool = false
    @Published var isLoginShown = false
    @Published var isUsernameAvailable: Bool?
    @Published var isUserNameLongEnough: Bool = true
    @Published var sheetType: SheetType?
    
    private var usernameCheckTask: Task<Bool?, Never>?
    
    override init() {
        super.init()
        subscribeToUsernameChange()
    }

    var isRegisterButtonDisabled: Bool {
        name.isEmpty || username.isEmpty || isUsernameAvailable != true || username.count >= 3 || password.isEmpty || email.isEmpty || !termsAccepted
    }
    
    var isCheckingUsernameAvailability: Bool {
        usernameCheckTask != nil
    }
    
    var usernameFieldIcon: String {
        if let isUsernameAvailable {
            return isUsernameAvailable ? "checkmark.circle.fill" : "xmark.circle.fill"
        } else {
            return ""
        }
    }
    
    var usernameFieldIconColor: Color {
        if let isUsernameAvailable {
            return isUsernameAvailable ? .Main.green: .Main.accentRed
        } else {
            return .clear
        }
    }

    var usernameFieldTitle: String {
        guard isUserNameLongEnough else {
            return String.Onboarding.username + " " + "(" + String.Onboarding.usernameLengthLimit + ")"
        }
        guard let isUsernameAvailable, !isUsernameAvailable else {
            return String.Profile.username
        }
        return String.Onboarding.username + " " + "(" + String.Onboarding.usernameIsTaken + ")"
    }
    
    var usernameFieldPlaceholderColor: Color {
        guard isUserNameLongEnough else {
            return .Main.accentRed
        }
        guard let isUsernameAvailable, !isUsernameAvailable else {
            return .Main.black
        }
        return .Main.accentRed
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
                try await userAPI.registerUser(name: name, username: username, email: email, password: password)
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
    
    private func subscribeToUsernameChange() {
        $username
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] username in
                guard let self else { return }
                self.isUsernameAvailable = nil
                guard !username.isEmpty else {
                    return
                }
                self.isUserNameLongEnough = username.count >= 3
                guard self.isUserNameLongEnough else {
                    return
                }
                self.checkUsernameAvailability(of: username)
            }
            .store(in: &publishers)
    }
    
    private func checkUsernameAvailability(of username: String) {
        usernameCheckTask?.cancel()
        usernameCheckTask = Task { () -> Bool? in
            do {
                return try await userAPI.checkAvailability(of: username)
            } catch {
                self.error = error
            }
            return nil
        }
        Task {
            self.isUsernameAvailable = await usernameCheckTask?.value
            usernameCheckTask = nil
        }
    }

}
