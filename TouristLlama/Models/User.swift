//
//  User.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation
import SwiftSDK

struct User: Identifiable {
    
    enum Property: String {
        case name
        case username
        case email
        case profilePicture
        case about
        case memberSince = "created"
        var string: String {
            return self.rawValue
        }
    }
    
    let id: String
    let name: String
    let username: String
    let email: String
    let about: String
    let profilePicture: String?
//    let sex: Sex
    let memberSince: Date?
    
    init(id: String, name: String, username: String, email: String, profilePicture: String?, about: String?, memberSince: Date?) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.profilePicture = profilePicture
        self.about = about ?? ""
        self.memberSince = memberSince
    }
    
    init?(from blUser: BackendlessUser) {
        guard let id = blUser.objectId,
              let name = blUser.name,
              let username = blUser.properties[Property.username.string] as? String,
              let email = blUser.email else {
            return nil
        }
        let profilePicture = blUser.properties[Property.profilePicture.string] as? String
        let about = blUser.properties[Property.about.string] as? String ?? ""
        let memberSince = blUser.properties[Property.memberSince.string] as? Date
        
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.profilePicture = profilePicture
        self.about = about
        self.memberSince = memberSince
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
        blUser.properties[Property.username.string] = self.username
        blUser.properties[Property.profilePicture.string] = self.profilePicture
        blUser.properties[Property.about.string] = self.about
        blUser.properties[Property.memberSince.string] = self.memberSince
        blUser.properties[Property.memberSince.string] = self.memberSince
        return blUser
    }
}

extension User: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
