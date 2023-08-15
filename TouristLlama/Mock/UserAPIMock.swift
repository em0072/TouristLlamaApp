//
//  UserAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPIMock: UserAPIProvider {
    
    let userImage: String = "https://images.unsplash.com/photo-1563409236302-8442b5e644df?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZHVja3xlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80"
    
    func getCurrentUser() async -> User? {
        return User(id: "1J74J-UFJ47-SIDJ5-IJ82W", name: "Bob", email: "bob@email.com", imageURLString: userImage)
    }
    
    func registerUser(name: String, email: String, password: String) async throws -> User {
        return User(id: "1J74J-UFJ47-SIDJ5-IJ82W", name: name, email: email, imageURLString: userImage)
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return
    }
    
    func login(email: String, password: String) async throws -> User {
        return User(id: "1J74J-UFJ47-SIDJ5-IJ82W", name: "Bob", email: email, imageURLString: userImage)
    }
    
    func login(token: String) async throws -> User {
        return User(id: "1J74J-UFJ47-SIDJ5-IJ82W", name: "", email: "bob@email.com", imageURLString: userImage)
    }
    
    func recoverPassword(email: String) async throws {}
    
    func logout() async throws {}
    
    func updateUserProperty(_ properties: [User.Property : Any]) async throws -> User {
        return User(id: "1J74J-UFJ47-SIDJ5-IJ82W", name: "Bob", email: "bob@email.com", imageURLString: userImage)
    }
}
