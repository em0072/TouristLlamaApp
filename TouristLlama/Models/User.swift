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
        case pronoun
        case email
        case phone
        case dateOfBirth
        case profilePicture
        case about
        case memberSince = "created"
        case friends
        
        var string: String {
            return self.rawValue
        }
    }
    
    let id: String
    let name: String
    let username: String
    let pronoun: Pronoun
    let email: String
    let phone: String
    let dateOfBirth: Date?
    let about: String
    let profilePicture: String?
//    let sex: Sex
    let memberSince: Date?
    let friends: [User]

    init(id: String, name: String, username: String, pronoun: Pronoun, email: String, phone: String, dateOfBirth: Date?, profilePicture: String?, about: String?, memberSince: Date?, friends: [User]) {
        self.id = id
        self.name = name
        self.username = username
        self.pronoun = pronoun
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.profilePicture = profilePicture
        self.about = about ?? ""
        self.memberSince = memberSince
        self.friends = friends
    }
    
    init?(from blUser: BackendlessUser) {
        guard let id = blUser.objectId,
              let name = blUser.name,
              let username = blUser.properties[Property.username.string] as? String,
              let email = blUser.email else {
            return nil
        }
        let phone = blUser.properties[Property.phone.string] as? String ?? ""
        let dateOfBirthTimeInterval = blUser.properties[Property.dateOfBirth.string] as? TimeInterval
        let profilePicture = blUser.properties[Property.profilePicture.string] as? String
        let about = blUser.properties[Property.about.string] as? String ?? ""
        let pronoun = Pronoun(rawValue: blUser.properties[Property.pronoun.string] as? String ?? "") ?? .none
        let memberSinceTimeInterval = blUser.properties[Property.memberSince.string] as? TimeInterval
        let blFriends = blUser.properties[Property.friends.string] as? [BackendlessUser] ?? []

        self.id = id
        self.name = name
        self.username = username
        self.pronoun = pronoun
        self.email = email
        self.phone = phone
        if let dateOfBirthTimeInterval {
            self.dateOfBirth = Date(timeIntervalSince1970Milliseconds: dateOfBirthTimeInterval)
        } else {
            self.dateOfBirth = nil
        }
        self.profilePicture = profilePicture
        self.about = about
        if let memberSinceTimeInterval {
            self.memberSince = Date(timeIntervalSince1970Milliseconds: memberSinceTimeInterval)
        } else {
            self.memberSince = nil
        }
        self.friends = blFriends.compactMap({ User(from: $0) })
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
        blUser.properties[Property.pronoun.string] = self.pronoun.rawValue
        blUser.properties[Property.profilePicture.string] = self.profilePicture
        blUser.properties[Property.phone.string] = self.phone
        blUser.properties[Property.dateOfBirth.string] = self.dateOfBirth?.timeIntervalSince1970Milliseconds
        blUser.properties[Property.about.string] = self.about
        blUser.properties[Property.memberSince.string] = self.memberSince
//        blUser.properties[Property.friends.string] = self.friends.map({ $0.blUser })
        return blUser
    }
}

extension User: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
