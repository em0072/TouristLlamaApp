//
//  MessagesView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 25/09/2023.
//

import Foundation

import SwiftUI
import MessageKit

struct MessagesView: UIViewControllerRepresentable {
    
    final class Coordinator: NSObject {
        let chat: TripChat
        let currentUser: User
        let chatParticipants: [String: User]
        var messages: [ChatMessage]
        let onSendButtonPress: (String) -> Void
        let onImagePress: (UIImage) -> Void

        // MARK: Lifecycle

        init(currentUser: User, chat: TripChat, chatParticipants: [String: User], messages: [ChatMessage], onImagePress: @escaping (UIImage) -> Void, onSendButtonPress: @escaping (String) -> Void) {
            self.currentUser = currentUser
            self.chat = chat
            self.chatParticipants = chatParticipants
            self.messages = messages
            self.onSendButtonPress = onSendButtonPress
            self.onImagePress = onImagePress
        }

        // MARK: Internal

        let formatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .medium
          return formatter
        }()

      }

    @State private var initialized = false
    let currentUser: User
    let chat: TripChat
    let chatParticipants: [String: User]
    @Binding var messages: [ChatMessage]
    let onMessageShow: (ChatMessage, Bool) -> Void
    let onMediaButtonPress: () -> Void
    let onSendButtonPress: (String) -> Void

    init(currentUser: User,
         chat: TripChat,
         chatParticipants: [String: User],
         messages: Binding<[ChatMessage]>,
         onMessageShow: @escaping (ChatMessage, Bool) -> Void,
         onMediaButtonPress: @escaping () -> Void,
         onSendButtonPress: @escaping (String) -> Void) {
        self.currentUser = currentUser
        self.chat = chat
        self.chatParticipants = chatParticipants
        self._messages = messages
        self.onMessageShow = onMessageShow
        self.onMediaButtonPress = onMediaButtonPress
        self.onSendButtonPress = onSendButtonPress
    }
    
    func makeUIViewController(context: Context) -> MessageSwiftUIVC {
        let messagesVC = MessageSwiftUIVC(messages: messages) { index in
            if index >= 0 && index < messages.count && initialized {
                onMessageShow(messages[index], true)
            }
        } onMessageDisappear: { index in
            if index >= 0 && index < messages.count && initialized {
                onMessageShow(messages[index], false)
            }
        }
        
        messagesVC.messagesCollectionView.register(InfoMessageCell.self)

        messagesVC.messagesCollectionView.messagesDisplayDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesLayoutDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesDataSource = context.coordinator
        messagesVC.messagesCollectionView.messageCellDelegate = messagesVC
        messagesVC.messageInputBar = InputBarView() {
            onMediaButtonPress()
        }
        messagesVC.messageInputBar.delegate = context.coordinator
        messagesVC.scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        messagesVC.maintainPositionOnInputBarHeightChanged = true // default false
        messagesVC.showMessageTimestampOnSwipeLeft = true // default false
        

        return messagesVC
      }
    
    
    func updateUIViewController(_ uiViewController: MessageSwiftUIVC, context: Context) {
        // Data Source Change
        let oldMessageCount = context.coordinator.messages.count
        let newMessageCount = messages.count
        let isAddingNewMessage = messages.last?.id != context.coordinator.messages.last?.id
        let isAddingOlderMessages = messages.first?.id != context.coordinator.messages.first?.id
        uiViewController.messages = messages
        
        // Layout Params
        let contentHeight = uiViewController.messagesCollectionView.contentSize.height
        let offsetY = uiViewController.messagesCollectionView.contentOffset.y
        let bottomOffset = contentHeight - offsetY
        
        // Update Data Source
        context.coordinator.messages = messages
        
        //Figure Out Colection View Animations
        if isAddingOlderMessages {
            // Adding Older Messages At The Top
            let numberOfSectionsToAdd = newMessageCount - oldMessageCount

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            uiViewController.messagesCollectionView.performBatchUpdates {
                let toAddIndexSet = IndexSet(integersIn: 0 ..< numberOfSectionsToAdd)
                uiViewController.messagesCollectionView.insertSections(toAddIndexSet)
            } completion: { finished in
                uiViewController.messagesCollectionView.setContentOffset(.init(x: 0, y: uiViewController.messagesCollectionView.contentSize.height - bottomOffset), animated: false)
                CATransaction.commit()
            }
        } else if isAddingNewMessage {
            // Adding New Message On The Bottom
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            uiViewController.messagesCollectionView.performBatchUpdates {
                let toAddIndexSet = IndexSet(integersIn: oldMessageCount ..< newMessageCount)
                uiViewController.messagesCollectionView.insertSections(toAddIndexSet)
            } completion: { finished in
                CATransaction.commit()
                scrollToBottom(uiViewController)
                print("Scroll To Bottom On New Message")
            }
        } else {
            // Nothing To Add, So Just Update The Cells
            uiViewController.messagesCollectionView.reloadData()
            // Scroll Only If Collection View Was Not Initialised Before, Otherwise UI Will Always Jump To The Bottom
            if !initialized {
                scrollToBottom(uiViewController, animated: false)
                print("Scroll To Bottom On init")
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(currentUser: currentUser, chat: chat, chatParticipants: chatParticipants, messages: messages, onImagePress: { image in
            
        }, onSendButtonPress: onSendButtonPress)
    }

    private func scrollToBottom(_ uiViewController: MessagesViewController, animated: Bool = true) {
      DispatchQueue.main.async {
        // The initialized state variable allows us to start at the bottom with the initial messages without seeing the initial scroll flash by
        uiViewController.messagesCollectionView.scrollToLastItem(animated: animated)
        self.initialized = true
      }
    }
}


// MARK: - MessagesView.Coordinator + MessagesDataSource

extension MessagesView.Coordinator: MessagesDataSource {
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
        
    var currentSender: SenderType {  currentUser  }

    func numberOfSections(in _: MessagesCollectionView) -> Int {
    messages.count
  }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.section]
        if message.position == .first || message.position == .only && !isFromCurrentSender(message: message) {
            return NSAttributedString(
                string: message.author.name,
                attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
  }

    func messageBottomLabelAttributedText(for message: MessageKit.MessageType, at _: IndexPath) -> NSAttributedString? {
        return nil
  }

    func messageTimestampLabelAttributedText(for message: MessageKit.MessageType, at _: IndexPath) -> NSAttributedString? {
    let sentDate = message.sentDate
    let sentDateString = MessageKitDateFormatter.shared.string(from: sentDate)
    let timeLabelFont: UIFont = .boldSystemFont(ofSize: 10)
    let timeLabelColor: UIColor = .systemGray
    return NSAttributedString(
      string: sentDateString,
      attributes: [NSAttributedString.Key.font: timeLabelFont, NSAttributedString.Key.foregroundColor: timeLabelColor])
  }
    
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        guard case .custom(let type) = message.kind,
              let messageType = type as? ChatMessage.CustomCellKind else {
            return UICollectionViewCell()
        }
        switch messageType {
        case .info(let text):
            let cell = messagesCollectionView.dequeueReusableCell(InfoMessageCell.self, for: indexPath)
            cell.configure(with: text)
            return cell
        case .newMessages:
            fatalError("Provide Message Cell")
        }
    }
}
