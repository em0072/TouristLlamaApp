//
//  BackendlessTripPhoto.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation

@objcMembers class BackendlessTripPhoto: NSObject, BackendlessObject, Codable {
    var objectId: String?
    var small: String?
    var medium: String?
    var large: String?
    
    override init() {
        super.init()
    }

    init(from tripPhoto: TripPhoto) {
        self.small = tripPhoto.small.absoluteString
        self.medium = tripPhoto.medium.absoluteString
        self.large = tripPhoto.large.absoluteString
    }
    
    init?(from dict: Any?) {
        guard let dict = dict as? [String: Any] else { return nil }
        self.small = dict[CodingKeys.small.stringValue] as? String
        self.medium = dict[CodingKeys.medium.stringValue] as? String
        self.large = dict[CodingKeys.large.stringValue] as? String
    }
    
    var appObject: TripPhoto? {
        guard let smallString = self.small, let small = URL(string: smallString) else { return nil }
        guard let mediumString = self.medium, let medium = URL(string: mediumString) else { return nil }
        guard let largeString = self.large, let large = URL(string: largeString) else { return nil }

        return TripPhoto(small: small,
                         medium: medium,
                         large: large)
    }
    

}
