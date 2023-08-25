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
//    private let channel: Channel
    private var channels: [Channel] = []
    private var channelSubscriptions: [RTSubscription?] = []
    private var timer: Timer?
    
    init() {
        print("ChatAPIBackendless is ALIVE")
//        channel = Backendless.shared.messaging.subscribe(channelName: "TripMessages")
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
        print("Checking if the channel with name '\(chatId)' is already created")
        guard !hasChannel(with: chatId) else { return }
        print("Creating a new channel")
        let newChannel = Backendless.shared.messaging.subscribe(channelName: chatId)
        print("Creating a new subscription")
        let subscriptionString = newChannel.addCustomObjectMessageListener(forClass: BackendlessChatMessage.self) { response in
            guard let blChatMessage = response as? BackendlessChatMessage else {
                print("Can't cast to backendless object")
                return
            }
            guard let chatMessage = blChatMessage.appObject else {
                print("Can't convert to app object")
                return
            }
            print("Provider got a new messge with text \(chatMessage.text)")
            onNewMessage(chatMessage)
        } errorHandler: { error in
            print("Error: \(error.message ?? "")")
        }
        print("Channel and subscription are created")
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
