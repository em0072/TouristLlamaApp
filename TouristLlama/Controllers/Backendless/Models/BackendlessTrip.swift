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
    var lastMessage: BackendlessChatMessage?
    var isPublic: Bool = false
    var participants: [BackendlessUser] = []
    var ownerId: String?
    var chat: BackendlessTripChat?
    var requests: [BackendlessTripReqest] = []
    
    override init() {
        super.init()
    }
    
    init(from trip: Trip) {
        self.objectId = trip.id
        self.ownerId = trip.ownerId
        self.name = trip.name
        self.style = trip.style?.rawValue
        self.location = BackendlessTripLocation(from: trip.location)
        self.startDate = trip.startDate
        self.endDate = trip.endDate
        self.tripDescription = trip.description
        self.photo = BackendlessTripPhoto(from: trip.photo)
        if let lastMessage = trip.lastMessage {
            self.lastMessage = BackendlessChatMessage(from: lastMessage)
        }
        self.isPublic = trip.isPublic
        self.participants = trip.participants.map { $0.blUser }
        self.chat = BackendlessTripChat(from: trip.chat)
        self.requests = trip.requests.map { BackendlessTripReqest(from: $0) }
    }
        
    var appObject: Trip? {
        guard let objectId,
              let name,
              let location = self.location?.appObject,
              let startDate,
              let endDate,
              let tripDescription,
              let photo = self.photo?.appObject,
              let ownerId else { return nil }
        
        let style = TripStyle(rawValue: style ?? "")
        let requests = self.requests.compactMap { $0.appObject }
        let lastMessage = self.lastMessage?.appObject
        
        return Trip(id: objectId,
                    name: name,
                    style: style,
                    location: location,
                    startDate: startDate,
                    endDate: endDate,
                    description: tripDescription,
                    photo: photo,
                    lastMessage: lastMessage,
                    isPublic: isPublic,
                    participants: self.participants.compactMap { User(from: $0) },
                    ownerId: ownerId,
                    requests: requests
        )
    }
    
}
