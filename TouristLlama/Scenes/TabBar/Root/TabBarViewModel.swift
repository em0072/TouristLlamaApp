//
//  TabBarViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import Foundation
import Dependencies

class TabBarViewModel: ViewModel {
    @Dependency(\.userAPI) var userAPI
    
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
