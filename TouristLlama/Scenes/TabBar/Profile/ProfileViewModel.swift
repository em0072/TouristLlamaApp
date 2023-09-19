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
    @Published var isUserBlocked: Bool = false
    @Published var counter: (tripsCount: Int, friendsCount: Int)?
    @Published var userToEditProfile: User?
    @Published var isReportingViewOpen = false
    @Published var isBlockingViewOpen = false
    @Published var isLogoutConfirmationShown: Bool = false
    #if DEBUG
    @Published var isDebugOpen: Bool = false
    #endif
    
    init(user: User?) {
        self.user = user
        super.init()
        getUpdatedUser()
//        getUserCounters()
        
    }
    
    var isCurrentUser: Bool {
        return user?.id == userAPI.currentUser?.id
    }
    
    var blockConfirmationTitle: String {
        isUserBlocked ? String.Main.unblockTitle : String.Main.blockTitle
    }
    
    var blockConfirmationMessage: String {
        isUserBlocked ? String.Main.unblockMessage : String.Main.blockMessage
    }

    var blockConfirmationActionString: String {
        isUserBlocked ? String.Main.unblock : String.Main.block
    }
    
    var blockMenuButtonTitle: String {
        isUserBlocked ? String.Main.unblock : String.Main.block
    }

    var blockMenuButtonIcon: String {
        isUserBlocked ? "person.crop.circle.badge.checkmark.fill" : "person.crop.circle.badge.xmark.fill"
    }

    func blockConfirmationAction() {
        if isUserBlocked {
            unblockUser()
        } else {
            blockUser()
        }
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
                    self.user = try await userAPI.get(userId: userToLoad.id)
                } catch {
                    self.error = error
                }
            }
            checkIfUserIsBlocked(userId: userToLoad.id)
        }
    }
    
    private func checkIfUserIsBlocked(userId: String) {
        Task {
            do {
                self.isUserBlocked = try await userAPI.checkIfUserBlocked(userId: userId)
            } catch {
                self.error = error
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
    
    func getUserCounters() {
        Task {
            do {
                if let user {
                    counter = try await userAPI.getUserCounters(userId: user.id)
                }
            } catch {
                self.error = error
            }
        }
    }
    
    func reportUserButtonAction() {
        isReportingViewOpen = true
    }
    
    func blockUserButtonAction() {
        isBlockingViewOpen = true
    }
        
    func reportUser(reason: String) {
        guard let user else { return }
        loadingState = .loading
        Task {
            do {
                try await userAPI.reportUser(userId: user.id, reason: reason)
                loadingState = .none
                isReportingViewOpen = false
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    private func blockUser() {
        guard let user else { return }
        loadingState = .loading
        Task {
            do {
                try await userAPI.blockUser(userId: user.id)
                loadingState = .none
                isBlockingViewOpen = false
                isUserBlocked = true
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    private func unblockUser() {
        guard let user else { return }
        loadingState = .loading
        Task {
            do {
                try await userAPI.unblockUser(userId: user.id)
                loadingState = .none
                isBlockingViewOpen = false
                isUserBlocked = false
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }

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
