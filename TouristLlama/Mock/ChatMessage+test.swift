//
//  ChatMessage+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 17/08/2023.
//

import Foundation

extension ChatMessage {
    
    static var test: ChatMessage {
        let author = User.test
        let number = Int.random(in: 0...100)
        let count = Int.random(in: 0...30)
        let message = "\(Array(repeating: number, count: count))"
        return ChatMessage(objectId: UUID().uuidString, clientId: UUID().uuidString, ownerId: author.id, chatId: "asdasdq", text: message, author: author, created: Date(), type: .user)
    }
    
    static var testNotOwner: ChatMessage {
        let author = User.testNotOwner
        let number = Int.random(in: 0...100)
        let count = Int.random(in: 0...30)
        let message = "\(Array(repeating: number, count: count))"

        return ChatMessage(objectId: UUID().uuidString, clientId: UUID().uuidString, ownerId: author.id, chatId: "asdasdq", text: message, author: author, created: Date(), type: .user)
    }

}
