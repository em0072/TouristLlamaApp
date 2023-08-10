//
//  ContentViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import Foundation
import Dependencies

class ContentViewModel: ViewModel {
    @Dependency(\.userAPI) var userAPI
    
    enum LoginStatus {
        case notDetermined
        case loggedOut
        case loggedIn
    }
    
    @Published var loginStatus: LoginStatus = .notDetermined
        
    override func subscribeToUpdates() {
        userAPI.$currentUser
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] currentUser in
                self?.loginStatus = currentUser == nil ? .loggedOut : .loggedIn
            }
            .store(in: &publishers)
    }    
}
