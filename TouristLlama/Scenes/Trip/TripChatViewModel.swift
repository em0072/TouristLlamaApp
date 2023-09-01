//
//  TripChatViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import SwiftUI
import Dependencies
import ExyteChat

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
                determineNewMessagePlankPosition()
            }
        }
    }
    
    @Published var messages: [Message] = []
    @Published var chatMessageText: String = ""
    @Published private var lastReadMessage: ChatMessage?
    @Published var newMessagesChatId: String?
    @Published private var chatViewSelected: Bool = false

    
    init(chat: TripChat?) {
        self.chat = chat
        super.init()
        subscribeToChatUpdates()
        subscribeToLastReadMessage()
    }
    
    var lastReadMessageId: String? {
        guard let tripId = chat?.tripId else { return nil }
        return userDefaultsController.getLastMessageIf(for: tripId)
    }
    
    func shouldShowNewMessageText(after message: ChatMessage) -> Bool {
        message.id == newMessagesChatId
    }
    
    func onAppear() {
        determineNewMessagePlankPosition()
        objectWillChange.send()
        if let lastMessage = chat?.messages.last {
            markMessageAsRead(message: lastMessage)
        }
    }
    
    func determineNewMessagePlankPosition() {
        let lastReadMessageId = lastReadMessageId
        if chat?.messages.last?.id == lastReadMessageId {
            newMessagesChatId = nil
        } else {
            newMessagesChatId = lastReadMessageId
        }
    }
    
    func setChatViewSelected(_ selected: Bool) {
        self.chatViewSelected = selected
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
        if previousMessage.ownerId == message.ownerId && previousMessage.type == .user {
            return false
        } else {
            return true
        }
    }
    
    func isOutgoing(message: ChatMessage) -> Bool {
        return userAPI.currentUser?.id == message.ownerId
    }

    func resend(message: DraftMessage) {
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
    }

    func resend(message: ChatMessage) {
        guard let messageIndex = chat?.messages.firstIndex(of: message) else {
            self.error = CustomError(text: "Can't resend the message")
            return
        }
        chat?.messages[messageIndex].status = .sending
        Task {
            do {
                let sentMessage = try await chatAPI.sendChatMessage(message: message)
                markMessageAsRead(message: sentMessage)
            } catch {
                markMessageAsNotSent(message: message)
                self.error = error
            }
        }
    }

    func markMessageAsNotSent(message: ChatMessage) {
        if let messageIndex = chat?.messages.firstIndex(of: message) {
            chat?.messages[messageIndex].status = .error
        }
    }
    
    func markMessageAsRead(message: ChatMessage) {
        if let lastReadMessage {
            if message.created > lastReadMessage.created {
                self.lastReadMessage = message
            }
        } else {
            lastReadMessage = message
        }
    }
    
    func send(draftMessage: DraftMessage) {
        guard let chatId = chat?.id else {
            self.error = CustomError(text: "Couldn't determin chat Id")
            return
        }
        guard let currentUser = userAPI.currentUser else {
            self.error = CustomError(text: "Current User is not found - can't send the message")
            return
        }

        Task {
            let message = ChatMessage(chatId: chatId, text: draftMessage.text, author: currentUser)
            insertMessageIfNeeded(message)
            Task {
                do {
                    let sentMessage = try await chatAPI.sendChatMessage(message: message)
                    markMessageAsRead(message: sentMessage)
                } catch {
                    markMessageAsNotSent(message: message)
                    self.error = error
                }
            }
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
        guard let currentUser = userAPI.currentUser else {
            self.error = CustomError(text: "Current User is not found - can't send the message")
            return
        }
        let message = ChatMessage(chatId: chatId, text: chatMessageText, author: currentUser)
        chatMessageText.removeAll()
        insertMessageIfNeeded(message)
        Task {
            do {
                let sentMessage = try await chatAPI.sendChatMessage(message: message)
                markMessageAsRead(message: sentMessage)
            } catch {
                markMessageAsNotSent(message: message)
                self.error = error
            }
        }
    }
    
    private func mapMessages() {
        guard let chat, let currentUser = userAPI.currentUser else { return }
        messages = chat.messages.compactMap({ chatMessage in
            let chatMessageAuthor = chatMessage.author ?? User.info
            
            let isAuthorCurrentUser = chatMessageAuthor.id == currentUser.id
            let author = ExyteChat.User(id: chatMessageAuthor.id, name: chatMessageAuthor.name, avatarURL: chatMessageAuthor.imageURL, isCurrentUser: isAuthorCurrentUser)
            
            return Message(id: chatMessage.id, user: author, status: .sent, createdAt: chatMessage.created, text: chatMessage.text, attachments: [], recording: nil, replyMessage: nil)
        })
    }
    
    private func subscribeToChatUpdates() {
        guard let chatId = chat?.id else { return }
        chatAPI.subscribeToChatUpdates(for: chatId)
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                self.insertMessageIfNeeded(message)
            }
            .store(in: &publishers)
    }
    
    private func subscribeToLastReadMessage() {
        $lastReadMessage
            .compactMap { $0 }
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] lastMessage in
                guard let self else { return }
                guard let tripId = self.chat?.tripId,
                let messageId = lastMessage.objectId else { return }
                self.userDefaultsController.saveLast(messageId: messageId, for: tripId)
            }
            .store(in: &publishers)
    }

    private func insertMessageIfNeeded(_ message: ChatMessage) {
        if userAPI.currentUser?.id != message.ownerId {
            chat?.messages.append(message)
        } else if let messageIndex = chat?.messages.firstIndex(where: { $0.clientId == message.clientId}) {
            chat?.messages[messageIndex] = message
        } else {
            chat?.messages.append(message)
        }
    }

}
