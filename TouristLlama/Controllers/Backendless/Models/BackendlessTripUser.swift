////
////  BackendlessTripUser.swift
////  TouristLlama
////
////  Created by Evgeny Mitko on 15/08/2023.
////

import Foundation
import SwiftSDK

//@objcMembers final class BackendlessTripUser: NSObject, Codable {
//    var objectId: String?
//    var name: String?
//    var imageURLString: String?
//
//    override init() {
//        super.init()
//    }
//    
//    init(from user: User) {
//        self.name = user.name
//        self.imageURLString = user.imageURLString
//    }
//    
//    init?(from dict: Any?) {
//        guard let dict = dict as? [String: Any] else { return nil }
//        self.name = dict[CodingKeys.name.stringValue] as? String
//        self.imageURLString = dict[CodingKeys.imageURLString.stringValue] as? String
//    }
//    
//    var appObject: User? {
//        guard let objectId else { return nil }
//        guard let name else { return nil }
//
//        return User(id: objectId, name: name, email: "", imageURLString: self.imageURLString)
//    }
//    
//}

//extension BackendlessUser: Codable {
//    convenience init(from user: User) {
//            self.init()
//            self.objectId = user.id
//            self.name = user.name
//
//            self.imageURLString = user.imageURLString
//        }
//}
