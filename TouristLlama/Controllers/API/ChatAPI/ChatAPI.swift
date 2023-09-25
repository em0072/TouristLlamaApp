//
//  ChatAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation
import Combine
import Dependencies

class ChatAPI {
    
    private let provider: ChatAPIProvider
    
    let pageSize: Int = 100
        
    init(provider: ChatAPIProvider) {
        self.provider = provider
    }

    func subscribeToChatUpdates(for chatIds: [String], onNewMessage: @escaping (ChatMessage) -> Void) {
        provider.subscribeToChatUpdates(for: chatIds, onNewMessage: onNewMessage)
    }
        
    func getTripChat(tripId: String, pageOffset: Int = 0) async throws -> TripChat {
        try await provider.getChat(tripId: tripId, pageSize: pageSize, pageOffset: pageOffset)
    }

    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage {
        try await provider.sendChatMessage(message: message)
    }
    
}
