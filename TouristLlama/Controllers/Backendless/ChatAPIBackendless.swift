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
    private var channels: [Channel] = []
    private var channelSubscriptions: [RTSubscription?] = []
    private var timer: Timer?
    
    init() {
        print("ChatAPIBackendless is ALIVE")
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            print("TIMER", "channels", self.channels.count, self.channels.map( { $0 }))
            print("TIMER", "sunscriptions", self.channelSubscriptions.count, self.channelSubscriptions.map( { $0 }))

        })
    }
    
    deinit {
        print("ChatAPIBackendless is DEAD")
    }
    
    func getChat(for tripId: String) async throws -> TripChat {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = tripId
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
    
    private func hasChannel(with name: String) -> Bool {
        for channel in channels {
            if channel.channelName == name {
                return true
            }
        }
        return false
    }
    
    func subscribeToChatUpdates(for chatId: String, onNewMessage: @escaping (ChatMessage) -> Void) {
        guard !hasChannel(with: chatId) else { return }
        let newChannel = Backendless.shared.messaging.subscribe(channelName: chatId)
        let subscriptionString = newChannel.addCustomObjectMessageListener(forClass: BackendlessChatMessage.self) { response in
            guard let blChatMessage = response as? BackendlessChatMessage else {
                return
            }
            guard let chatMessage = blChatMessage.appObject else {
                return
            }
            onNewMessage(chatMessage)
        } errorHandler: { error in
        }
        channelSubscriptions.append(subscriptionString)
        channels.append(newChannel)
        newChannel.join()
    }
    
    func sendChatMessage(message: ChatMessage) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let message = BackendlessChatMessage(from: message)
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "postChatMessage", parameters: message) { response in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
}
