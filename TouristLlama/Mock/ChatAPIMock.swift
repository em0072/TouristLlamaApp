//
//  ChatAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

class ChatAPIMock: ChatAPIProvider {
        
    func getChat(for tripId: String) async throws -> TripChat {
        TripChat.test(numberOfMessages: 25)
    }
    
    func subscribeToChatUpdates(for chatId: String, onNewMessage: @escaping (ChatMessage) -> Void) {}
    
    func sendChatMessage(message: ChatMessage) async throws {}
}
