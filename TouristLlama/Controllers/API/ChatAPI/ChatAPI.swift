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
    @Dependency(\.tripsAPI) var tripsAPI

    private let provider: ChatAPIProvider
    
    let pageSize: Int = 100
    
//    var publishers: [String: PassthroughSubject<ChatMessage, Never>] = [:]
    
    init(provider: ChatAPIProvider) {
        self.provider = provider
    }

    func subscribeToChatUpdates(for chatIds: [String], onNewMessage: @escaping (ChatMessage) -> Void) {
        provider.subscribeToChatUpdates(for: chatIds, onNewMessage: onNewMessage)
    }
    
//    func subscribeToChatUpdates(for chatId: String) -> AnyPublisher<ChatMessage, Never> {
//        if let exictingPublisher = publishers[chatId] {
//            return exictingPublisher.eraseToAnyPublisher()
//        }
//        let publisher = PassthroughSubject<ChatMessage, Never>()
//        publishers[chatId] = publisher
//        provider.subscribeToChatUpdates(for: chatId) { [weak self] message in
//            guard let self else { return }
//            self.publishers[chatId]?.send(message)
////            self.tripsAPI.updateLastMessage(chatId: chatId, message: message)
//        }
//        return publisher.eraseToAnyPublisher()
//    }
    
    func getTripChat(tripId: String, pageOffset: Int = 0) async throws -> TripChat {
        try await provider.getChat(tripId: tripId, pageSize: pageSize, pageOffset: pageOffset)
    }

    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage {
        try await provider.sendChatMessage(message: message)
    }
    
}
