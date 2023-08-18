//
//  BackendlessTripChat.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

@objcMembers class BackendlessTripChat: NSObject, BackendlessObject {
    var objectId: String?
    var ownerId: String?
    var tripId: String?
    var messages: [BackendlessChatMessage] = []

    override init() {
        super.init()
    }

    init?(from tripChat: TripChat?) {
        guard let tripChat else { return nil }
        self.objectId = tripChat.id
        self.ownerId = tripChat.ownerId
        self.tripId = tripChat.tripId
        self.messages = tripChat.messages.map { BackendlessChatMessage(from: $0) }
    }
        
    var appObject: TripChat? {
        guard let objectId,
              let ownerId,
              let tripId else { return nil }
        
        let messages = self.messages.compactMap { $0.appObject }
        
        return TripChat(id: objectId, ownerId: ownerId, tripId: tripId, messages: messages)
    }
}
