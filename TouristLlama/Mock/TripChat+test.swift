//
//  TripChat+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 17/08/2023.
//

import Foundation

extension TripChat {
    
    static func test(numberOfMessages: Int = 1) -> TripChat {
        var messages: [ChatMessage] = []
        for _ in 0..<numberOfMessages {
            let isOutgoing = Bool.random()
            messages.append(isOutgoing ? ChatMessage.test : ChatMessage.testNotOwner)
        }
        return TripChat(id: "1qw32d", ownerId: User.test.id, tripId: Trip.testOngoing.id, messages: messages)
    }
    
}
