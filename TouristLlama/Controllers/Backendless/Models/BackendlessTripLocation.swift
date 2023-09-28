//
//  BackendlessTripLocation.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation
import CoreLocation
import SwiftSDK

@objcMembers class BackendlessTripLocation: NSObject, BackendlessObject, Codable {
    var objectId: String?
    var title: String?
    var country: String?
    var latitude: Double = .zero
    var longitude: Double = .zero
    var flag: String?

    override init() {
        super.init()
    }

    init(from tripLocation: TripLocation) {
        self.objectId = nil
        self.title = tripLocation.title
        self.country = tripLocation.country
        if let coordinate = tripLocation.point?.coordinate {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
        self.flag = tripLocation.flag
    }
    
    init?(from dict: Any?) {
        guard let dict = dict as? [String: Any] else { return nil }
        self.objectId = dict[CodingKeys.objectId.stringValue] as? String
        self.title = dict[CodingKeys.title.stringValue] as? String
        self.country = dict[CodingKeys.country.stringValue] as? String
        self.latitude = dict[CodingKeys.latitude.stringValue] as? Double ?? .zero
        self.longitude = dict[CodingKeys.longitude.stringValue] as? Double ?? .zero
        self.flag = dict[CodingKeys.flag.stringValue] as? String

    }
    
    var appObject: TripLocation? {
        guard let title else { return nil }
        guard let country else { return nil }
        guard let flag else { return nil }

        return TripLocation(title: title,
                     country: country,
                     point: .init(latitude: latitude, longitude: longitude),
                     flag: flag)
    }
    
}

