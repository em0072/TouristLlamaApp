//
//  UserAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPI {
    
    private let provider: UserAPIProvider
    
    @Published var currentUser: User?
    
    init(provider: UserAPIProvider) {
        self.provider = provider
        self.updateCurrentUser()
    }
    
    private func updateCurrentUser() {
        Task { @MainActor in
            currentUser = await provider.getCurrentUser()
        }
    }
        
    @discardableResult
    func registerUser(name: String, username: String, email: String, password: String) async throws -> User {
        return try await provider.registerUser(name: name, username: username, email: email, password: password)
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return try await provider.resendConfirmationEmail(email: email)
    }
    
    @discardableResult
    func login(email: String, password: String) async throws -> User {
        let user = try await provider.login(email: email, password: password)
        currentUser = user
        return user
    }
    
    @discardableResult
    func login(token: String) async throws -> User {
        let user = try await provider.login(token: token)
        currentUser = user
        return user
    }

    func recoverPassword(email: String) async throws {
        return try await provider.recoverPassword(email: email)
    }
    
    func logOut() async throws {
        try await provider.logout()
        currentUser = nil
    }
    
    @discardableResult
    func updateUserProperty(_ properties: [User.Property: Any]) async throws -> User {
        let updatedUser = try await provider.updateUserProperty(properties)
        currentUser = updatedUser
        return updatedUser
    }
    
    func get(userId: String) async throws -> User {
        try await provider.get(userId: userId)
    }
    
    func getUserCounters(userId: String) async throws -> (tripsCount: Int, friendsCount: Int) {
        try await provider.getUserCounters(userId: userId)
    }
    
    func checkAvailability(of username: String) async throws -> Bool {
        try await provider.checkAvailability(of: username)
    }
    
    func uploadProfilePicture(data: Data) async throws -> String {
        try await provider.uploadProfilePicture(data: data)
    }
    
    func searchUsers(searchPrompt: String) async throws -> [User] {
        try await provider.searchUsers(searchPrompt: searchPrompt)
    }
    
    func getCurrentUserFriends() async throws -> [User] {
        try await provider.getCurrentUserFriends()
    }
    
    func addFriend(userId: String) async throws -> [User] {
        try await provider.addFriend(userId: userId)
    }
    
    func removeFriend(userId: String) async throws -> [User] {
        try await provider.removeFriend(userId: userId)
    }

    func reportUser(userId: String, reason: String) async throws {
        try await provider.reportUser(userId: userId, reason: reason)
    }
    
    func blockUser(userId: String) async throws {
        try await provider.blockUser(userId: userId)
    }
    
    func unblockUser(userId: String) async throws {
        try await provider.unblockUser(userId: userId)
    }
    
    func checkIfUserBlocked(userId: String) async throws -> Bool {
        try await provider.checkIfUserBlocked(userId: userId)
    }

}
