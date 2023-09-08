//
//  SearchingUsersViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 30/08/2023.
//

import Foundation
import Dependencies

class SearchingUsersViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var searchPrompt = "" {
        didSet {
            if searchPrompt.isEmpty {
                users.removeAll()
                state = .content
            }
        }
    }
    @Published var users: [User] = []
    @Published var friends: [User] = []
    @Published var selectedUser: User?
    
    override init() {
        super.init()
//        state = .content
        getCurrentUserFriends()
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToSearchTerm()
    }
    
    private func getCurrentUserFriends() {
        Task {
            do {
                friends = try await userAPI.getCurrentUserFriends()
                state = .content
            } catch {
                print(error)
                state = .content
            }
        }
    }
        
    private func subscribeToSearchTerm() {
        $searchPrompt
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] searchTerm in
                if !searchTerm.isEmpty {
                    self?.searchUsers()
                }
            }
            .store(in: &publishers)
    }
    
    func cellTapAction(for user: User) {
        selectedUser = user
    }
    
    private func searchUsers() {
        state = .loading
        Task {
            do {
                users = try await userAPI.searchUsers(searchPrompt: searchPrompt)
                state = .content
            } catch {
                self.error = error
                state = .content
            }
        }
    }

    

}
