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
    
    private let serviceName = "UserService"
        
    func registerUser(name: String, username: String, email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation{ continuation in
            
            let user = BackendlessUser()
            user.name = name
            user.email = email
            user.password = password
            user.properties[User.Property.username.string] = username
            
            Backendless.shared.userService.registerUser(user: user) { registredUser in
                guard let user = User(from: registredUser) else {
                    continuation.resume(throwing: CustomError(text: "can't cast BackendlessUser to User"))
                    return
                }
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
                guard let user = User(from: loggedInUser) else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
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
                guard let user = User(from: loggedInUser) else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
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
                guard let user = User(from: updatedUser) else {
                    continuation.resume(throwing: UserAPIError.responceIsEmpty)
                    return
                }
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
        Backendless.shared.userService.reloadCurrentUser = true
        guard let backendlessUser = Backendless.shared.userService.currentUser else { return nil }
        guard let user = User(from: backendlessUser) else {
            return nil
        }
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
    
    func get(userId: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getUser", parameters: userId) { response in
                guard let backendlessUser = response as? BackendlessUser else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to backendless object"))
                    return
                }
                guard let user = User(from: backendlessUser) else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse backendless object to app object"))
                    return
                }
                continuation.resume(returning: user)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getUserCounters(userId: String) async throws -> (tripsCount: Int, friendsCount: Int) {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getUserCounter", parameters: userId) { response in
                guard let dict = response as? [String: Any] else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to a dictionary"))
                    return
                }
                let tripsCount = (dict["tripsCount"] as? Int) ?? 0
                let friendsCount = (dict["friendsCount"] as? Int) ?? 0
                
                continuation.resume(returning: (tripsCount: tripsCount, friendsCount: friendsCount))
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }

    func checkAvailability(of username: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let username = username
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getUsernameAvailability", parameters: username) { response in
                guard let isAvailable = response as? Bool else {
                    continuation.resume(throwing: CustomError(text: "Cannot parse data to a boolean"))
                    return
                }
                continuation.resume(returning: isAvailable)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func uploadProfilePicture(data: Data) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            guard let objectId = Backendless.shared.userService.currentUser?.objectId else {
                continuation.resume(throwing: CustomError(text: "No current user is available"))
                return
            }
            let fileName = "\(Date().timeIntervalSince1970)"
            let filePath = "users/\(objectId)/photos/profilePictures"
            Backendless.shared.file.uploadFile(fileName: fileName, filePath: filePath, content: data, overwrite: true) { file in
                guard let fileUrl = file.fileUrl else {
                    continuation.resume(throwing: CustomError(text: "File upload returned empty file url"))
                    return
                }
                continuation.resume(returning: fileUrl)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func searchUsers(searchPrompt: String) async throws -> [User] {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "searchUsers", parameters: searchPrompt) { response in
                guard let backendlessUsersArray = response as? [BackendlessUser] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let users = backendlessUsersArray.compactMap { User(from: $0) }
                continuation.resume(returning: users)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getCurrentUserFriends() async throws -> [User] {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getCurrentUserFriends", parameters: nil) { response in
                guard let backendlessUsersArray = response as? [BackendlessUser] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let users = backendlessUsersArray.compactMap { User(from: $0) }
                continuation.resume(returning: users)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addFriend(userId: String) async throws -> [User] {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = userId
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "addFriend", parameters: parameters) { response in
                guard let backendlessUsersArray = response as? [BackendlessUser] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let users = backendlessUsersArray.compactMap { User(from: $0) }
                continuation.resume(returning: users)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    
    func removeFriend(userId: String) async throws -> [User] {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = userId
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "removeFriend", parameters: parameters) { response in
                guard let backendlessUsersArray = response as? [BackendlessUser] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let users = backendlessUsersArray.compactMap { User(from: $0) }
                continuation.resume(returning: users)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }

    func reportUser(userId: String, reason: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String: Any] = ["userId": userId, "reason": reason]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "reportUser", parameters: parameters) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func blockUser(userId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = userId
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "blockUser", parameters: parameters) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func unblockUser(userId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = userId
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "unblockUser", parameters: parameters) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func checkIfUserBlocked(userId: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = userId
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "checkIfUserBlocked", parameters: parameters) { response in
                guard let bool = response as? Bool else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to Boolean"))
                    return
                }
                continuation.resume(returning: bool)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }

    }

}
