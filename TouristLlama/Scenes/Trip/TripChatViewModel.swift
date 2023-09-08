//
//  TripChatViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import SwiftUI
import Dependencies

@MainActor
class TripChatViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.chatAPI) var chatAPI
    @Dependency(\.userDefaultsController) var userDefaultsController

    @Published var chat: TripChat? {
        didSet {
            if oldValue?.id != chat?.id {
                mapMessages()
                subscribeToChatUpdates()
            }
        }
    }
    
    @Published var messages: [ChatMessage] = []
    @Published var chatMessageText: String = ""
    @Published var shouldShowScrollButton: Bool = false

    var pageOffset: Int = 1
    var canDownloadMoreMessages = false

    private var lastReadMessage: ChatMessage? {
        didSet {
            if let lastReadMessage, let chat {
                userDefaultsController.saveLast(messageId: lastReadMessage.id, for: chat.tripId)
            }
        }
    }
    
    init(chat: TripChat?) {
        self.chat = chat
        super.init()
        mapMessages()
        subscribeToChatUpdates()
    }
    
    private func setViewModelState() {
        self.state = chat == nil ? .loading : .content
    }
        
    func isMessageFromCurrentUser(_ message: ChatMessage) -> Bool {
        message.ownerId == userAPI.currentUser?.id
    }
    
    func isTitleMessage(_ message: ChatMessage) -> Bool {
        let messageId = message.id
        guard let index = messages.firstIndex(where: { $0.id == messageId }) else { return false }
        if index == 0 { return true }
        let previousIndex = index - 1
        let previousMessage = messages[previousIndex]
        if previousMessage.type == .info { return true }
        if previousMessage.ownerId == message.ownerId { return false }
        return true
    }
    
    func markEndOfChat(isEnd: Bool) {
        if isEnd {
            guard shouldShowScrollButton else { return }
            shouldShowScrollButton = false
        } else {
            guard !shouldShowScrollButton else { return }
            shouldShowScrollButton = true
        }
    }
    
    
    func updateChat(with chat: TripChat?) {
        if chat?.id != self.chat?.id {
            self.chat = chat
        }
        setViewModelState()
    }

    func resend(message: ChatMessage) {
        guard let messageIndex = messages.firstIndex(of: message) else {
            self.error = CustomError(text: "Can't resend the message")
            return
        }
        messages[messageIndex].status = .sending
        Task {
            do {
                let sentMessage = try await chatAPI.sendChatMessage(message: message)
                insertMessageIfNeeded(sentMessage)
            } catch {
                markMessageAsNotSent(messageId: message.id)
            }
        }
    }

//    func resend(message: ChatMessage) {
//        guard let messageIndex = chat?.messages.firstIndex(of: message) else {
//            self.error = CustomError(text: "Can't resend the message")
//            return
//        }
//        chat?.messages[messageIndex].status = .sending
//        Task {
//            do {
//                let sentMessage = try await chatAPI.sendChatMessage(message: message)
//                markMessageAsRead(message: sentMessage)
//            } catch {
//                markMessageAsNotSent(message: message)
//                self.error = error
//            }
//        }
//    }

//    func markMessageAsNotSent(message: ChatMessage) {
//        if let messageIndex = chat?.messages.firstIndex(of: message) {
//            chat?.messages[messageIndex].status = .error
//        }
//    }
    

    func sendChatMessage() {
        guard let chatId = chat?.id else {
            self.error = CustomError(text: "Couldn't determin chat Id")
            return
        }
        guard let currentUser = userAPI.currentUser else {
            self.error = CustomError(text: "Current User is not found - can't send the message")
            return
        }
        guard !chatMessageText.isEmpty else { return }
        Task {
            let message = ChatMessage(chatId: chatId, text: chatMessageText, author: currentUser)
            insertMessageIfNeeded(message)
            markAsRead(message)
            chatMessageText.removeAll()
            Task {
                do {
                    let sentMessage = try await chatAPI.sendChatMessage(message: message)
                    self.insertMessageIfNeeded(sentMessage)
//                    markMessageAsSent(messageId: sentMessage.id)
                } catch {
                    markMessageAsNotSent(messageId: message.id)
                }
            }
        }
    }
        
    func markAsRead(_ message: ChatMessage) {
        if let lastReadMessage {
            if message.created > lastReadMessage.created {
                self.lastReadMessage = message
                print("LAST READ MESSAGE - \(message.text)")
            }
        } else {
            lastReadMessage = message
            print("LAST READ MESSAGE - \(message.text)")
        }
    }
    
    func downloadOlderMessages() {
        guard let chat, canDownloadMoreMessages else { return }
        Task {
            do {
                let chat = try await chatAPI.getTripChat(tripId: chat.tripId, pageOffset: pageOffset)
                let messages = chat.messages
                canDownloadMoreMessages = messages.count == chatAPI.pageSize
                addOlderMessages(messages)
                pageOffset += 1
            } catch {
                self.error = error
            }
        }
    }
    
    private func mapMessages() {
        setViewModelState()
        guard let chat else { return }
        var messages = [ChatMessage]()
        let lastReadMessageId = userDefaultsController.getLastMessageIf(for: chat.tripId)
        for message in chat.messages {
            
            if message.id == lastReadMessageId {
                lastReadMessage = message
            }
            messages.insert(message, at: 0)

        }
        self.messages = messages
        
        canDownloadMoreMessages = messages.count == chatAPI.pageSize
    }
    
    private func addOlderMessages(_ olderMessages: [ChatMessage]) {
//        canScrollDown = false
        olderMessages.forEach({ messages.insert($0, at: 0) })
//        canScrollDown = true
    }
    
    private func markMessageAsNotSent(messageId: String) {
        if let messageIndex = messages.firstIndex(where: { $0.id == messageId }) {
                messages[messageIndex].status = .error
            }
        }
    
    private func markMessageAsSent(messageId: String) {
        if let messageIndex = messages.firstIndex(where: { $0.id == messageId }) {
                messages[messageIndex].status = .sent
            }
        }

        
    private func subscribeToChatUpdates() {
        guard let chatId = chat?.id else { return }
        chatAPI.subscribeToChatUpdates(for: chatId)
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                guard message.author != self.userAPI.currentUser else { return }
                self.insertMessageIfNeeded(message)
            }
            .store(in: &publishers)
    }
    
    private func insertMessageIfNeeded(_ message: ChatMessage) {
        if let messageIndex = messages.firstIndex(where: { $0.id == message.id}) {
            messages[messageIndex] = message
        } else {
            messages.append(message)
        }
    }
    
}
