//
//  APIProvider.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation

protocol UserAPIProvider {
    func registerUser(name: String, email: String, password: String) async throws -> User
    func resendConfirmationEmail(email: String) async throws
}
