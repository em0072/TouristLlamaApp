//
//  BackendlessTrip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation
import SwiftSDK

@objcMembers final class BackendlessTrip: NSObject {
    var objectId: String?
    var name: String?
    var style: String?
    var location: BackendlessTripLocation?
    var startDate: Date?
    var endDate: Date?
    var tripDescription: String?
    var photo: BackendlessTripPhoto?
    var isPublic: Bool = false
    var participants: [BackendlessUser] = []
    
    override init() {
        super.init()
    }
    
    init(from trip: Trip) {
        self.name = trip.name
        self.style = trip.style?.rawValue
        self.location = BackendlessTripLocation(from: trip.location)
        self.startDate = trip.startDate
        self.endDate = trip.endDate
        self.tripDescription = trip.description
        self.photo = BackendlessTripPhoto(from: trip.photo)
        self.isPublic = trip.isPublic
        self.participants = trip.participants.map { $0.blUser }
    }
        
    var appObject: Trip? {
        guard let name else { return nil }
        guard let location = self.location?.appObject else { return nil }
        guard let startDate else { return nil }
        guard let endDate else { return nil }
        guard let tripDescription else { return nil }
        guard let photo = self.photo?.appObject else { return nil }
        
        let style = TripStyle(rawValue: style ?? "")
        
        return Trip(name: name,
                    style: style,
                    location: location,
                    startDate: startDate,
                    endDate: endDate,
                    description: tripDescription,
                    photo: photo,
                    isPublic: isPublic,
                    participants: self.participants.compactMap { User(from: $0) }
        )
    }
    
}
