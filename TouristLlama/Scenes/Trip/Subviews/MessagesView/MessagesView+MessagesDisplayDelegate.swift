//
//  MessagesView+MessagesDisplayDelegate.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/09/2023.
//

import SwiftUI
import MessageKit
import Kingfisher

extension MessagesView.Coordinator: MessagesDisplayDelegate {
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let mediaItem):
            imageView.kf.cancelDownloadTask() // first, cancel currenct download task
            if let image = mediaItem.image {
                imageView.image = image
            } else {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: mediaItem.url)
            }
        default:
            return
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        switch message.kind {
        case .text:
            return [.address, .date, .phoneNumber, .transitInformation, .url]
        default:
            return []
        }
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key : Any] {
        [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let message = messages[indexPath.section]
        let position = message.position
        let isIncoming = message.ownerId != currentUser.id
        let messageStyle: MessageStyle
        switch position {
        case .first, .only:
            messageStyle = MessageStyle.bubbleTail(isIncoming ? .topLeft : .topRight, .curved)
        default:
            messageStyle = MessageStyle.bubble
        }
        return messageStyle
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == currentUser.id {
            return UIColor(Color.Chat.outgoingBubble)
        } else {
            return UIColor(Color.Chat.incomingBubble)
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in _: MessagesCollectionView) {
        let message = messages[indexPath.section]
        if message.position == .first || message.position == .only {
            avatarView.isHidden = false
        } else {
            avatarView.isHidden = true
            return
        }
        let initials =
        if !message.sender.displayName.isEmpty {
            message.sender.displayName.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        } else {
            ""
        }
        let avatar = Avatar(initials: initials)
        avatarView.set(avatar: avatar)
        
        guard let avatarUrl = getAuthorAvatarImageUrl(authorId: message.sender.senderId) else { return }
        KingfisherManager.shared.retrieveImage(with: avatarUrl) { result in
            switch result {
            case .success(let imageResult):
                let avatar = Avatar(image: imageResult.image)
                avatarView.set(avatar: avatar)
            case .failure:
                return
            }
        }
    }
    
    private func getAuthorAvatarImageUrl(authorId: String) -> URL? {
        chatParticipants[authorId]?.imageURL
    }
}
