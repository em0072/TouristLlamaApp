//
//  UserBackendless.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation
import SwiftSDK

class UserAPIBackendless: UserAPIProvider {
    
    enum UserAPIError: Error {
        case requestFailed
        case responceIsEmpty
    }
        
    func registerUser(name: String, email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation{ continuation in
            
            let user = BackendlessUser()
            user.name = name
            user.email = email
            user.password = password
            
            Backendless.shared.userService.registerUser(user: user) { registredUser in
                guard let id = registredUser.objectId,
                      let name = registredUser.name,
                        let email = registredUser.email else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
                let user = User(id: id, name: name, email: email)
                continuation.resume(returning: user)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return try await withCheckedThrowingContinuation{ continuation in
            Backendless.shared.userService.resendEmailConfirmation(identity: email) {
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
}
