//
//  ChatAPIProvider.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

protocol ChatAPIProvider {
    func getChat(tripId: String, pageSize: Int, pageOffset: Int) async throws -> TripChat
    func subscribeToChatUpdates(for chatIds: [String], onNewMessage: @escaping (ChatMessage) -> Void)
    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage
    func uploadImage(id: String, chatId: String,  data: Data) async throws -> String
}
