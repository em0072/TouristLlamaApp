//
//  TripChatViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import SwiftUI
import Dependencies

class TripChatViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.chatAPI) var chatAPI
    
    @Published var chat: TripChat? {
        didSet {
            if oldValue?.id != chat?.id {
                subscribeToChatUpdates()
            }
        }
    }
    @Published var chatMessageText: String = ""
    
    init(chat: TripChat?) {
        self.chat = chat
        super.init()
        subscribeToChatUpdates()
    }
    
    func updateChat(with chat: TripChat?) {
        if chat?.id != self.chat?.id {
            self.chat = chat
        }
    }

    func isFirstFormAuthor(message: ChatMessage) -> Bool {
        
        guard let messages = chat?.messages, let messageIndex = messages.firstIndex(of: message)
        else { return false }
        let previousMessageIndex = messageIndex - 1
        
        guard previousMessageIndex >= 0 else {
            return true
        }
        let previousMessage = messages[previousMessageIndex]
        if previousMessage.ownerId == message.ownerId {
            return false
        } else {
            return true
        }
    }
    
    func isOutgoing(message: ChatMessage) -> Bool {
        return userAPI.currentUser?.id == message.ownerId
    }

    func resend(message: ChatMessage) {
        guard let messageIndex = chat?.messages.firstIndex(of: message) else {
            self.error = CustomError(text: "Can't resend the message")
            return
        }
        chat?.messages[messageIndex].status = .sending
        Task {
            do {
                try await chatAPI.sendChatMessage(message: message)
            } catch {
                markMessageAsNotSent(message: message)
                self.error = error
            }
        }
    }

    @MainActor
    func markMessageAsNotSent(message: ChatMessage) {
        if let messageIndex = chat?.messages.firstIndex(of: message) {
            chat?.messages[messageIndex].status = .error
        }
    }
    
    func sendChatMessage() {
        guard let chatId = chat?.id else {
            self.error = CustomError(text: "Couldn't determin chat Id")
            return
        }
        guard !chatMessageText.isEmpty else {
            self.error = CustomError(text: "Chat Message is empty")
            return
        }
        let message = ChatMessage(chatId: chatId, text: chatMessageText, ownerId: userAPI.currentUser?.id ?? "")
        chatMessageText.removeAll()
        insertMessageIfNeeded(message)
        Task {
            do {
                try await chatAPI.sendChatMessage(message: message)
            } catch {
                markMessageAsNotSent(message: message)
                self.error = error
            }
        }
    }
    
    private func subscribeToChatUpdates() {
        publishers.removeAll()
        guard let chatId = chat?.id else { return }
        chatAPI.subscribeToChatUpdates(for: chatId)
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                self.insertMessageIfNeeded(message)
            }
            .store(in: &publishers)
    }

    @MainActor
    private func insertMessageIfNeeded(_ message: ChatMessage) {
        if userAPI.currentUser?.id != message.ownerId {
            chat?.messages.append(message)
        } else if let messageIndex = chat?.messages.firstIndex(of: message) {
            chat?.messages[messageIndex].status = .sent
        } else {
            chat?.messages.append(message)
        }
    }

}
