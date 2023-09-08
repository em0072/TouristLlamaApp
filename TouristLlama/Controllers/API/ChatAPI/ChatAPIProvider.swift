//
//  ChatAPIProvider.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

protocol ChatAPIProvider {
    func getChat(tripId: String, pageSize: Int, pageOffset: Int) async throws -> TripChat
    func subscribeToChatUpdates(for chatId: String, onNewMessage: @escaping (ChatMessage) -> Void)
    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage 
}
