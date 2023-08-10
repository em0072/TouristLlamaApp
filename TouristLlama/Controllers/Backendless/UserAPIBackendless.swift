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
    
    func login(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation{ continuation in
            Backendless.shared.userService.stayLoggedIn = true
            Backendless.shared.userService.login(identity: email, password: password) { loggedInUser in
                guard let id = loggedInUser.objectId,
                      let email = loggedInUser.email else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
                let name = loggedInUser.name ?? ""
                let user = User(id: id, name: name, email: email)
                continuation.resume(returning: user)
                
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func login(token: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = token
            Backendless.shared.userService.stayLoggedIn = true
            Backendless.shared.customService.invoke(serviceName: "AppleAuth", method: "login", parameters: parameters) { loggedInUser in
                guard let loggedInUser = loggedInUser as? BackendlessUser else {
                    continuation.resume(throwing: CustomError(text: "Couldn't convert object to BackendlessUser type"))
                    return
                }
                Backendless.shared.userService.currentUser = loggedInUser
                guard let id = loggedInUser.objectId,
                      let email = loggedInUser.email else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
                let name = loggedInUser.name ?? ""
                let user = User(id: id, name: name, email: email)

                continuation.resume(returning: user)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func updateUserProperty(_ properties: [User.Property: Any]) async throws -> User {
        return try await withCheckedThrowingContinuation{ continuation in
            
            guard let user = Backendless.shared.userService.currentUser else {
                continuation.resume(throwing: CustomError(text: "Couldn't fetch current user"))
                return
            }
            for (property, value) in properties {
                user.properties[property.string] = value
            }
            Backendless.shared.userService.update(user: user) { updatedUser in
                guard let id = updatedUser.objectId,
                      let email = updatedUser.email else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
                let name = updatedUser.name ?? ""
                let user = User(id: id, name: name, email: email)
                continuation.resume(returning: user)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func recoverPassword(email: String) async throws {
        return try await withCheckedThrowingContinuation{ continuation in
            Backendless.shared.userService.restorePassword(identity: email) {
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getCurrentUser() async -> User? {
        guard let backendlessUser = Backendless.shared.userService.currentUser else { return nil }
        guard let id = backendlessUser.objectId,
              let email = backendlessUser.email else {
            return nil
        }
        let name = backendlessUser.name ?? ""
        let user = User(id: id, name: name, email: email)
        return user
    }
    
    func logout() async throws {
        return try await withCheckedThrowingContinuation{ continuation in
            Backendless.shared.userService.logout {
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
}
