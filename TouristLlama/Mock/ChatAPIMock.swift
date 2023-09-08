//
//  ChatAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

class ChatAPIMock: ChatAPIProvider {
        
    func getChat(tripId: String, pageSize: Int, pageOffset: Int) async throws -> TripChat {
        TripChat.test(numberOfMessages: pageSize)
    }
    
    func subscribeToChatUpdates(for chatId: String, onNewMessage: @escaping (ChatMessage) -> Void) {}
    
    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage {
        .test
    }
}
