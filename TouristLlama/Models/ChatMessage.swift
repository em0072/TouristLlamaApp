//
//  DiscussionMessage.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation

struct ChatMessage: Identifiable {
    enum MessageType: String {
        case user
        case info
    }
    
    enum MessageStatus {
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
    let type: MessageType
    var status: MessageStatus?
    
    init(objectId: String, clientId: String, ownerId: String, chatId: String, text: String, author: User?, type: MessageType) {
        self.objectId = objectId
        self.clientId = clientId
        self.ownerId = ownerId
        self.chatId = chatId
        self.text = text
        self.author = author
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
        self.type = .user
        self.status = .sending
    }
}


extension ChatMessage: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.clientId == rhs.clientId
    }
}
