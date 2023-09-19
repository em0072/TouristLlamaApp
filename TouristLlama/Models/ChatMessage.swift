//
//  DiscussionMessage.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    enum MessageType: String, Hashable {
        case user
        case info
        case newMessages
    }
    
    enum MessageStatus: Hashable {
        case sending
        case sent
        case error
    }
    
    var id: String { return clientId }
    let objectId: String?
    let clientId: String
    let ownerId: String?
    let chatId: String
    let text: String
    let author: User?
    let created: Date
    let type: MessageType
    var status: MessageStatus?
    
    init(objectId: String, clientId: String, ownerId: String, chatId: String, text: String, author: User?, created: Date, type: MessageType) {
        self.objectId = objectId
        self.clientId = clientId
        self.ownerId = ownerId
        self.chatId = chatId
        self.text = text
        self.author = author
        self.created = created
        self.type = type
        self.status = .sent
    }
    
    init(chatId: String, text: String, author: User) {
        self.objectId = nil
        self.clientId = UUID().uuidString
        self.ownerId = author.id
        self.chatId = chatId
        self.text = text
        self.author = author
        self.created = Date()
        self.type = .user
        self.status = .sending
    }
    
    init(chatId: String, text: String, author: User, status: MessageStatus) {
        self.objectId = nil
        self.clientId = UUID().uuidString
        self.ownerId = author.id
        self.chatId = chatId
        self.text = text
        self.author = author
        self.created = Date()
        self.type = .user
        self.status = status
    }

    
    static var newMessages: ChatMessage {
        ChatMessage(objectId: "newMessages", clientId: "newMessages", ownerId: "", chatId: "", text: "New Messages", author: nil, created: Date(), type: .newMessages)
    }
}


extension ChatMessage: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.clientId == rhs.clientId
        && lhs.status == rhs.status
    }
}
