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
    var image: String?
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
        self.image = chatMessage.image?.url?.absoluteString
        self.author = chatMessage.author.blUser
        self.created = chatMessage.created
        self.type = chatMessage.type.rawValue
    }
        
    var appObject: ChatMessage? {
        guard let objectId,
              let clientId,
              let ownerId,
              let chatId,
              let created else { return nil }

        let user: User
        if let blAuthor = self.author, let author = User(from: blAuthor) {
            user = author
        } else {
            user = User.emptyUser
        }
        let text = text ?? ""
        let type = ChatMessage.MessageType(rawValue: self.type ?? "") ?? .userText
        return ChatMessage(objectId: objectId, clientId: clientId, ownerId: ownerId, chatId: chatId, text: text, image: image, author: user, created: created, type: type)
    }
}
