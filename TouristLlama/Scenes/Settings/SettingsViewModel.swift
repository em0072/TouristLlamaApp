//
//  SettingsViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import Foundation
import Dependencies

class SettingsViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var isLogoutConfirmationShown: Bool = false

    func logoutButtonAction() {
        isLogoutConfirmationShown = true
    }
    
    func logout() {
        Task {
            do {
                try await userAPI.logOut()
            } catch {
                self.error = error
            }
        }
    }
    
}
