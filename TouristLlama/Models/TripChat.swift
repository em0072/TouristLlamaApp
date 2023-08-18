//
//  TripDiscussion.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

struct TripChat: Identifiable {
    let id: String
    let ownerId: String
    let tripId: String
    var messages: [ChatMessage]
}
