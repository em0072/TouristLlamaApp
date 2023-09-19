//
//  ChatAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

class ChatAPIMock: ChatAPIProvider {
        
    func getChat(tripId: String, pageSize: Int, pageOffset: Int) async throws -> TripChat {
        if tripId == "testAmsterdam" {
            return .testAmsterdam
        } else {
            return TripChat.test(numberOfMessages: pageSize)
        }
    }
    
    func subscribeToChatUpdates(for chatIds: [String], onNewMessage: @escaping (ChatMessage) -> Void) {
    }
    
    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage {
        .test
    }
}
