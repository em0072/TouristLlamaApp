//
//  UserAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPIMock: UserAPIProvider {
    
    func getCurrentUser() async -> User? {
        return User.testBob
    }
    
    func registerUser(name: String, username: String, email: String, password: String) async throws -> User {
        return User.test
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return
    }
    
    func login(email: String, password: String) async throws -> User {
        return User.test
    }
    
    func login(token: String, givenName: String?, familyName: String?) async throws -> User {
        return User.test
    }
    
    func recoverPassword(email: String) async throws {}
    
    func logout() async throws {}
    
    func updateUserProperty(_ properties: [User.Property : Any]) async throws -> User {
        return User.test
    }
    
    func get(userId: String) async throws -> User {
        .testNotOwner
    }
    
    func getUserCounters(userId: String) async throws -> (tripsCount: Int, friendsCount: Int) {
        return (tripsCount: 23, friendsCount: 234)
    }
    
    func checkAvailability(of username: String) async throws -> Bool {
        Bool.random()
    }
    
    func uploadProfilePicture(data: Data) async throws -> String {
        return "https://upload.wikimedia.org/wikipedia/commons/9/91/2019_Tesla_Model_3_Performance_AWD_Front.jpg"
    }
    
    func searchUsers(searchPrompt: String) async throws -> [User] {
        return [.testNoPhoto, .testNotOwner, .testNotInvited]
    }
    
    func getCurrentUserFriends() async throws -> [User] {
        [.testNotOwner, .testNoPhoto]
    }
    
    func addFriend(userId: String) async throws -> [User] {
        [.testNotOwner, .testNoPhoto]
    }
    
    func removeFriend(userId: String) async throws -> [User] {
        [.testNotOwner]
    }

    func reportUser(userId: String, reason: String) async throws {
        
    }
    
    func blockUser(userId: String) async throws {
        
    }
    
    func unblockUser(userId: String) async throws {
        
    }

    func checkIfUserBlocked(userId: String) async throws -> Bool {
        return true
    }

}
