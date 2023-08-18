//
//  User.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation
import SwiftSDK

struct User: Codable, Identifiable {
    
    enum Property: String {
        case name
        case email
        case profilePicture

        var string: String {
            return self.rawValue
        }
    }
    
    let id: String
    let name: String
    let email: String
    let profilePicture: String?
//    let sex: Sex
//    let memberSince: Date
    
    init(id: String, name: String, email: String, imageURLString: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.profilePicture = imageURLString
    }
    
    init?(from blUser: BackendlessUser) {
        guard let id = blUser.objectId,
              let email = blUser.email else {
            return nil
        }
        let name = blUser.name ?? ""
        let imageURLString = blUser.properties[CodingKeys.profilePicture.stringValue] as? String

        self.id = id
        self.name = name
        self.email = email
        self.profilePicture = imageURLString
    }
    
    var imageURL: URL? {
        if let profilePicture {
            return URL(string: profilePicture)
        } else {
            return nil
        }
    }
    
    var blUser: BackendlessUser {
        let blUser = BackendlessUser()
        blUser.objectId = self.id
        blUser.name = self.name
        blUser.properties[CodingKeys.profilePicture.stringValue] = self.profilePicture
        return blUser
    }
}

extension User: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
