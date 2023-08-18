//
//  UserAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPIMock: UserAPIProvider {
    
    func getCurrentUser() async -> User? {
        return User.test
    }
    
    func registerUser(name: String, email: String, password: String) async throws -> User {
        return User.test
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return
    }
    
    func login(email: String, password: String) async throws -> User {
        return User.test
    }
    
    func login(token: String) async throws -> User {
        return User.test
    }
    
    func recoverPassword(email: String) async throws {}
    
    func logout() async throws {}
    
    func updateUserProperty(_ properties: [User.Property : Any]) async throws -> User {
        return User.test
    }
}
