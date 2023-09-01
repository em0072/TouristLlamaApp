//
//  BackendlessChatMessage.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation
import SwiftSDK

@objcMembers class BackendlessChatMessage: NSObject, BackendlessObject {
    var objectId: String?
    var clientId: String?
    var ownerId: String?
    var chatId: String?
    var text: String?
    var author: BackendlessUser?
    var created: Date?
    var type: String?
    
    override init() {
        super.init()
    }
    
    init(from chatMessage: ChatMessage) {
        self.objectId = chatMessage.objectId
        self.clientId = chatMessage.clientId
        self.ownerId = chatMessage.ownerId
        self.chatId = chatMessage.chatId
        self.text = chatMessage.text
        self.author = chatMessage.author?.blUser
        self.created = chatMessage.created
        self.type = chatMessage.type.rawValue
    }
        
    var appObject: ChatMessage? {
        guard let objectId,
              let clientId,
              let ownerId,
              let chatId,
              let created,
              let text else { return nil }

        var user: User?
        if let author {
            user = User(from: author)
        }
        let type = ChatMessage.MessageType(rawValue: self.type ?? "") ?? .user
        return ChatMessage(objectId: objectId, clientId: clientId, ownerId: ownerId, chatId: chatId, text: text, author: user, created: created, type: type)
    }
}
