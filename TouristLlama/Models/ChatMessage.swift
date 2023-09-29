//
//  DiscussionMessage.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation
import MessageKit

struct ChatMessage: Identifiable, Hashable {
    enum MessageType: String, Hashable {
        case userText
        case userImage
        case info
        case newMessages
        
        var isUser: Bool {
            switch self {
            case .userText, .userImage:
                return true
            case .info, .newMessages:
                return false
            }
        }
    }
    
    enum CustomCellKind {
        case info(String)
        case newMessages
    }
    
    enum MessageStatus: Hashable {
        case sending
        case sent
        case error
    }
    
    enum MessagePosition {
        case first
        case middle
        case last
        case only
        
        mutating func reverse() {
            switch self {
            case .first:
                self = .last
            case .last:
                self = .first
            default:
                return
            }
        }
    }
    
    var id: String { return clientId }
    let objectId: String?
    let clientId: String
    let ownerId: String?
    let chatId: String
    let text: String
    var image: ChatMessageMediaItem?
    let author: User
    let created: Date
    let type: MessageType
    var status: MessageStatus?
    var position: MessagePosition?
    
    init(objectId: String, clientId: String, ownerId: String, chatId: String, text: String, image: String?, author: User, created: Date, type: MessageType) {
        self.objectId = objectId
        self.clientId = clientId
        self.ownerId = ownerId
        self.chatId = chatId
        self.text = text
        self.image = ChatMessageMediaItem(url: URL(string: image ?? ""))
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
        self.image = nil
        self.author = author
        self.created = Date()
        self.type = .userText
        self.status = .sending
    }
    
    init(chatId: String, text: String, author: User, status: MessageStatus) {
        self.objectId = nil
        self.clientId = UUID().uuidString
        self.ownerId = author.id
        self.chatId = chatId
        self.text = text
        self.image = nil
        self.author = author
        self.created = Date()
        self.type = .userText
        self.status = status
    }
    
    init(chatId: String, image: ChatMessageMediaItem, author: User) {
        self.objectId = nil
        self.clientId = UUID().uuidString
        self.ownerId = author.id
        self.chatId = chatId
        self.text = ""
        self.image = image
        self.author = author
        self.created = Date()
        self.type = .userImage
        self.status = .sending
    }

    
//    static var newMessages: ChatMessage {
//        ChatMessage(objectId: "newMessages", clientId: "newMessages", ownerId: "", chatId: "", text: "New Messages", author: nil, created: Date(), type: .newMessages)
//    }
}


extension ChatMessage: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.clientId == rhs.clientId
        && lhs.status == rhs.status
    }
}

extension ChatMessage: MessageType {
    var sender: MessageKit.SenderType { author }
    
    var messageId: String { id }
    
    var sentDate: Date { created }
    
    var kind: MessageKit.MessageKind {
        switch self.type {
        case .info:
            return .custom(CustomCellKind.info(text))
        case  .newMessages:
            return .custom(CustomCellKind.newMessages)

        case .userText:
            return .text(text)
            
        case .userImage:
            return .photo(image ?? ChatMessageMediaItem())
        }
    }
    
    
}
