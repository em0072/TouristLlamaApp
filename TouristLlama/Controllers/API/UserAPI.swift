//
//  UserAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPI {
    
    let provider: UserAPIProvider
    
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
    
    func getCurrentUser() async -> User? {
        await provider.getCurrentUser()
    }
    
    @discardableResult
    func registerUser(name: String, email: String, password: String) async throws -> User {
        return try await provider.registerUser(name: name, email: email, password: password)
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
}
