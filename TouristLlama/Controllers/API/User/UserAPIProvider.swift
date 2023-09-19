//
//  APIProvider.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

protocol UserAPIProvider {
    func getCurrentUser() async -> User?
    func registerUser(name: String, username: String, email: String, password: String) async throws -> User
    func resendConfirmationEmail(email: String) async throws
    func login(email: String, password: String) async throws -> User
    func login(token: String, givenName: String?, familyName: String?) async throws -> User
    func recoverPassword(email: String) async throws
    func logout() async throws
    func updateUserProperty(_ properties: [User.Property: Any]) async throws -> User
    func get(userId: String) async throws -> User
    func getUserCounters(userId: String) async throws -> (tripsCount: Int, friendsCount: Int)
    func checkAvailability(of username: String) async throws -> Bool
    func uploadProfilePicture(data: Data) async throws -> String
    func searchUsers(searchPrompt: String) async throws -> [User]
    func getCurrentUserFriends() async throws -> [User] 
    func addFriend(userId: String) async throws -> [User]
    func removeFriend(userId: String) async throws -> [User]
    func reportUser(userId: String, reason: String) async throws
    func blockUser(userId: String) async throws
    func unblockUser(userId: String) async throws
    func checkIfUserBlocked(userId: String) async throws -> Bool
}
