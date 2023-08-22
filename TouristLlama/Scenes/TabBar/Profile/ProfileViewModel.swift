//
//  ProfileViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import Foundation
import Dependencies

@MainActor
class ProfileViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var user: User?
    @Published var counter: (tripsCount: Int, friendsCount: Int)?
    @Published var userToEditProfile: User?

    
    init(user: User?) {
        self.user = user
        super.init()
        getUpdatedUser()
        getUserCounters()
    }
    
    var isCurrentUser: Bool {
        return user?.id == userAPI.currentUser?.id
    }
    
    func openEditProfile() {
        if isCurrentUser {
            userToEditProfile = userAPI.currentUser
        }
    }
    
    private func getUpdatedUser() {
        if let currentUser = userAPI.currentUser, user == currentUser || user == nil {
            user = currentUser
            subscribeToCurrentUserUpdatesIfNeeded()
        } else if let userToLoad = user {
            Task {
                do {
                    user = try await userAPI.get(user: userToLoad)
                } catch {
                    self.error = error
                }
            }
        }
    }
    
    private func subscribeToCurrentUserUpdatesIfNeeded() {
        if isCurrentUser {
            userAPI.$currentUser
                .receive(on: RunLoop.main)
                .sink { [weak self] currentUser in
                    self?.user = currentUser
                }
                .store(in: &publishers)
        }
    }
    
    private func getUserCounters() {
        Task {
            do {
                if let user {
                    counter = try await userAPI.getUserCounters(user: user)
                }
            } catch {
                self.error = error
            }
        }
    }
    
}
