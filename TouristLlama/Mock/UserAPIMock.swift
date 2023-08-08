//
//  UserAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

class UserAPIMock: UserAPIProvider {
    func registerUser(name: String, email: String, password: String) async throws -> User {
        return User(id: "1J74J-UFJ47-SIDJ5-IJ82W", name: name, email: email)
    }
    
    func resendConfirmationEmail(email: String) async throws {
        return
    }
}
