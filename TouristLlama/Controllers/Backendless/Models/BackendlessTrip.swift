//
//  BackendlessTrip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation

@objcMembers final class BackendlessTrip: NSObject, Codable {
    var objectId: String?
    var name: String?
    var style: String?
    var location: BackendlessTripLocation?
    var startDate: Date?
    var endDate: Date?
    var tripDescription: String?
    var photo: BackendlessTripPhoto?
    var isPublic: Bool = false
    
    override init() {
        super.init()
    }
    
    init(from trip: Trip) {
        self.name = trip.name
        self.style = trip.style.rawValue
        self.location = BackendlessTripLocation(from: trip.location)
        self.startDate = trip.startDate
        self.endDate = trip.endDate
        self.tripDescription = trip.description
        self.photo = BackendlessTripPhoto(from: trip.photo)
        self.isPublic = trip.isPublic
    }
    
    init?(from dict: Any?) {
        guard let dict = dict as? [String: Any] else { return nil }
        self.name = dict[CodingKeys.name.stringValue] as? String
        self.style = dict[CodingKeys.style.stringValue] as? String
        self.location = BackendlessTripLocation(from: dict[CodingKeys.location.stringValue])
        if let startTimestamp = dict[CodingKeys.startDate.stringValue] as? Double {
            self.startDate = Date(timeIntervalSince1970: startTimestamp / 1000)
        }
        if let endTimestamp = dict[CodingKeys.endDate.stringValue] as? Double {
            self.endDate = Date(timeIntervalSince1970: endTimestamp / 1000)
        }
        self.tripDescription = dict[CodingKeys.tripDescription.stringValue] as? String
        self.photo = BackendlessTripPhoto(from: dict[CodingKeys.photo.stringValue])
        self.isPublic = dict[CodingKeys.tripDescription.stringValue] as? Bool ?? false
    }
    
    var appObject: Trip? {
        guard let name else { return nil }
        guard let style = TripStyle(rawValue: style ?? "") else { return nil }
        guard let location = self.location?.appObject else { return nil }
        guard let startDate else { return nil }
        guard let endDate else { return nil }
        guard let tripDescription else { return nil }
        guard let photo = self.photo?.appObject else { return nil }

        return Trip(name: name,
             style: style,
             location: location,
             startDate: startDate,
             endDate: endDate,
             description: tripDescription,
             photo: photo,
             isPublic: isPublic)
    }
    
}

extension NSObject {
    func getPropertyType(name: String) -> Any.Type? {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if child.label! == name
            {
                return type(of: child.value)
            }
        }
        
        
        return nil
    }
    
}
