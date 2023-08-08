//
//  UserAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPI {
    
    var provider: UserAPIProvider
    
    init(provider: UserAPIProvider) {
        self.provider = provider
    }
    
    func registerUser(name: String, email: String, password: String) async throws -> User {
        return try await provider.registerUser(name: name, email: email, password: password)
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return try await provider.resendConfirmationEmail(email: email)
    }
}
