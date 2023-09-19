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
    
    static var testAmsterdam: TripChat {
        var messages: [ChatMessage] = []

        messages.append(.init(chatId: "1", text: "Hello everyone!", author: .testBob, status: .sent))
        messages.append(.init(chatId: "2", text: "Here is an update on the trip.", author: .testBob, status: .sent))
        messages.append(.init(chatId: "3", text: "I plan to stay at the Conscious Hotel Westerpark (https://conscioushotels.com/stay/westerpark) since it's relatively close to the Central Station as we will need it a lot and the price for this hotel is reasonable.", author: .testBob, status: .sent))

        messages.append(.init(chatId: "4", text: "Wow. It has a true Dutch architecture! Love it!", author: .testHanna, status: .sent))

        messages.append(.init(chatId: "5", text: "That is another reason I chose it. We want to soak in the true NL vibe, right?!", author: .testBob, status: .sent))

        messages.append(.init(chatId: "6", text: "Indeed!", author: .testHanna, status: .sent))

        return TripChat(id: "testAmsterdamChat", ownerId: User.testBob.id, tripId: "testAmsterdam", messages: messages.reversed())
    }

}
