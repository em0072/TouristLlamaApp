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
    
    @Dependency(\.userDefaultsController) var userDefaultsController
    
    private let provider: ChatAPIProvider
    
    var publishers: [String: PassthroughSubject<ChatMessage, Never>] = [:]
    
    init(provider: ChatAPIProvider) {
        self.provider = provider
    }

    func subscribeToChatUpdates(for chatId: String) -> AnyPublisher<ChatMessage, Never> {
        if let exictingPublisher = publishers[chatId] {
            return exictingPublisher.eraseToAnyPublisher()
        }
        let publisher = PassthroughSubject<ChatMessage, Never>()
        publishers[chatId] = publisher
        provider.subscribeToChatUpdates(for: chatId) { [weak self] message in
            guard let self else { return }
            publishers[chatId]?.send(message)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func getTripChat(for tripId: String) async throws -> TripChat {
        try await provider.getChat(for: tripId)
    }

    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage {
        try await provider.sendChatMessage(message: message)
    }
    
}
