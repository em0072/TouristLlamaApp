//
//  ChatAPIBackendless.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation
import SwiftSDK
import Combine

class ChatAPIBackendless: ChatAPIProvider {
    
    private let serviceName = "ChatService"
//    private var channels: [Channel] = []
//    private var channelSubscriptions: [RTSubscription?] = []
    private var chatsSubscription: RTSubscription?
    
    func getChat(tripId: String, pageSize: Int, pageOffset: Int) async throws -> TripChat {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters: [String : Any] = ["tripId": tripId, "pageSize": pageSize, "pageOffset": pageOffset]
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getTripChat", parameters: parameters) { response in
                guard let blTripDiscussion = response as? BackendlessTripChat else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to backendless object"))
                    return
                }
                guard let tripsDiscussion = blTripDiscussion.appObject else {
                    continuation.resume(throwing: CustomError(text: "Can't convert to app object"))
                    return
                }
                continuation.resume(returning: tripsDiscussion)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
//    private func hasChannel(with name: String) -> Bool {
//        for channel in channels {
//            if channel.channelName == name {
//                return true
//            }
//        }
//        return false
//    }
//
    func subscribeToChatUpdates(for chatIds: [String], onNewMessage: @escaping (ChatMessage) -> Void) {
        chatsSubscription?.stop()
        
        let eventHandlerClauseChat = Backendless.shared.data.of(BackendlessChatMessage.self).rt
        var whereClauseChatIdsString: String = ""
        for (i, chatId) in chatIds.enumerated() {
            whereClauseChatIdsString += "'\(chatId)'"
            if i != chatIds.count - 1 {
                whereClauseChatIdsString += ","
            }
        }
        let whereClauseChat = "chatId in (\(whereClauseChatIdsString))"
        chatsSubscription = eventHandlerClauseChat?.addUpsertListener(whereClause: whereClauseChat, responseHandler: { response in
            guard let blChatMessage = response as? BackendlessChatMessage else {
                return
            }
            guard let chatMessage = blChatMessage.appObject else {
                return
            }
            onNewMessage(chatMessage)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
    }

//    func subscribeToChatUpdates(for chatId: String, onNewMessage: @escaping (ChatMessage) -> Void) {
//        
//        let eventHandlerClauseTrip = Backendless.shared.data.of(BackendlessChatMessage.self).rt
//        let whereClauseTrip = "chatId = '\(chatId)'"
//        _ = eventHandlerClauseTrip?.addUpsertListener(whereClause: whereClauseTrip, responseHandler: { response in
//            guard let blChatMessage = response as? BackendlessChatMessage else {
//                return
//            }
//            guard let chatMessage = blChatMessage.appObject else {
//                return
//            }
//            onNewMessage(chatMessage)
//        }, errorHandler: { fault in
//            print("Error: \(fault.message ?? "")")
//        })
//    }
    
    func sendChatMessage(message: ChatMessage) async throws -> ChatMessage {
        return try await withCheckedThrowingContinuation { continuation in
            let message = BackendlessChatMessage(from: message)
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "postChatMessage", parameters: message) { response in
                guard let blChatMessage = response as? BackendlessChatMessage else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to backendless object"))
                    return
                }
                guard let chatMessage = blChatMessage.appObject else {
                    continuation.resume(throwing: CustomError(text: "Can't convert to app object"))
                    return
                }
                continuation.resume(returning: chatMessage)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
}
