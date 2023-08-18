//
//  ChatAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation
import Combine

class ChatAPI {
    
    private let provider: ChatAPIProvider
    
    var publishers: [String: PassthroughSubject<ChatMessage, Never>] = [:]
    
    init(provider: ChatAPIProvider) {
        self.provider = provider
    }

    func subscribeToChatUpdates(for chatId: String) -> AnyPublisher<ChatMessage, Never> {
        print("Trying to get a chat publisher (id: \(chatId)")
        if let exictingPublisher = publishers[chatId] {
            print("publisher found in dictionary")
            return exictingPublisher.eraseToAnyPublisher()
        }
        print("publisher NOT found in dictionary")
        print("Creating new publisher")
        let publisher = PassthroughSubject<ChatMessage, Never>()
        publishers[chatId] = publisher
        print("Subscribing to provider updates")
        provider.subscribeToChatUpdates(for: chatId) { [weak self] message in
            guard let self else { return }
            print("Publisher will post a new message with text '\(message.text)'")
            publishers[chatId]?.send(message)
        }
        print("Returning freshly made publisher")
        return publisher.eraseToAnyPublisher()
    }
    
    func getTripChat(for tripId: String) async throws -> TripChat {
        try await provider.getChat(for: tripId)
    }

    func sendChatMessage(message: ChatMessage) async throws {
        try await provider.sendChatMessage(message: message)
    }

}
