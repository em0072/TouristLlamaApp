//
//  MessagesView+MessagesLayoutDelegate.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/09/2023.
//

import SwiftUI
import MessageKit
import Kingfisher

// MARK: - MessagesView.Coordinator + MessagesLayoutDelegate, MessagesDisplayDelegate

extension MessagesView.Coordinator: MessagesLayoutDelegate {
    
    func customCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        guard case .custom(let type) = message.kind,
              let messageType = type as? ChatMessage.CustomCellKind else {
            return CellSizeCalculator()
        }
        switch messageType {
        case .info(let text):
            let cellSizeCalculator = CustomMessageSizeCalculator(text: text, layout: messagesCollectionView.messagesCollectionViewFlowLayout)
            return cellSizeCalculator
        case .newMessages:
            fatalError("Provide Message Size")
        }
        
    }
    
    func messageTopLabelHeight(for messageType: MessageKit.MessageType, at indexPath: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        let position = messages[indexPath.section].position
        if position == .first || position == .only {
            return isFromCurrentSender(message: messageType) ? 0 : 20
        } else {
            return 0
        }
    }
    
    
    func messageBottomLabelHeight(for _: MessageKit.MessageType, at indexPath: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        let position = messages[indexPath.section].position
        if position == .last || position == .only {
            return 8
        } else {
            return 4
        }
    }
}
