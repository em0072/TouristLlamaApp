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
    
    init(id: String, name: String, username: String, pronoun: Pronoun, email: String, phone: String, dateOfBirth: Date?, profilePicture: String?, about: String?, memberSince: Date?) {
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
    }
    
    init?(from blUser: BackendlessUser) {
        guard let id = blUser.objectId,
              let name = blUser.name,
              let username = blUser.properties[Property.username.string] as? String,
              let email = blUser.email else {
            return nil
        }
        let phone = blUser.properties[Property.phone.string] as? String ?? ""
        var dateOfBirth: Date?
        if let timeIntervalSince1970Milliseconds = blUser.properties[Property.dateOfBirth.string] as? TimeInterval {
            dateOfBirth = Date(timeIntervalSince1970Milliseconds: timeIntervalSince1970Milliseconds)
        }
        let profilePicture = blUser.properties[Property.profilePicture.string] as? String
        let about = blUser.properties[Property.about.string] as? String ?? ""
        let pronoun = Pronoun(rawValue: blUser.properties[Property.pronoun.string] as? String ?? "") ?? .none
        let memberSince = blUser.properties[Property.memberSince.string] as? Date
        
        self.id = id
        self.name = name
        self.username = username
        self.pronoun = pronoun
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.profilePicture = profilePicture
        self.about = about
        self.memberSince = memberSince
    }
    
    static var info: User {
        User(id: "info", name: "", username: "", pronoun: .none, email: "", phone: "", dateOfBirth: nil, profilePicture: nil, about: nil, memberSince: nil)
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
        blUser.properties[Property.memberSince.string] = self.memberSince
        return blUser
    }
}

extension User: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
