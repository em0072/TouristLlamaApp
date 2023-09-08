//
//  FriendsListViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 05/09/2023.
//

import Foundation
import Dependencies

class FriendsListViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var isSearchingForUsersShown: Bool = false
    
    var userFriends: [User] = []
    
    override init() {
        super.init()
        getUserFriends()
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
//        subscribeToCurrentUserUpdates()
    }
    
//    private func subscribeToCurrentUserUpdates() {
//        userAPI.$currentUser
//            .sink { [weak self] currentUser in
//                guard let self, let currentUser else { return }
//                self.userFriends = currentUser.friends
//            }
//            .store(in: &publishers)
//    }
    
    private func getUserFriends() {
        Task {
            do {
                userFriends = try await userAPI.getCurrentUserFriends()
                state = .content
            } catch {
                self.error = error
            }
        }
//        userFriends = userAPI.currentUser?.friends ?? []
    }
    
    func addNewFriendButtonAction() {
        isSearchingForUsersShown = true
    }
    
    func addFriend(_ user: User) {
        loadingState = .loading
        Task {
            do {
                let newFriendsList = try await userAPI.addFriend(userId: user.id)
                userFriends = newFriendsList
                loadingState = .none
                isSearchingForUsersShown = false
            } catch {
                self.error = error
                loadingState = .error(error)
            }
        }
    }
    
    func removeFriend(_ user: User) {
        let indexOfUser = userFriends.firstIndex(where: { $0.id == user.id })
        if let indexOfUser {
            userFriends.remove(at: indexOfUser)
        }
        loadingState = .loading
        Task {
            do {
                let newFriendsList = try await userAPI.removeFriend(userId: user.id)
                userFriends = newFriendsList
                loadingState = .none
                isSearchingForUsersShown = false
            } catch {
                self.error = error
                if let indexOfUser {
                    userFriends.insert(user, at: indexOfUser)
                }
                loadingState = .none
            }
        }
    }


    func isUserCanBeAdded(_ user: User) -> Bool {
        return !userFriends.contains(user)
    }
}
