//
//  MessagesView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 25/09/2023.
//

import Foundation

import SwiftUI
import InputBarAccessoryView
import MessageKit
import Kingfisher

struct MessagesView: UIViewControllerRepresentable {
    
//    @Environment(\.)
    
    final class Coordinator {
        let chat: TripChat
        let currentUser: User
        let chatParticipants: [String: User]
        var messages: [ChatMessage]
        let onSendButtonPress: (String) -> Void

        // MARK: Lifecycle

        init(currentUser: User, chat: TripChat, chatParticipants: [String: User], messages: [ChatMessage], onSendButtonPress: @escaping (String) -> Void) {
            self.currentUser = currentUser
            self.chat = chat
            self.chatParticipants = chatParticipants
            self.messages = messages
            self.onSendButtonPress = onSendButtonPress
        }

        // MARK: Internal

        let formatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .medium
          return formatter
        }()

      }

    @State private var initialized = false
    private var messagesVC: MessageSwiftUIVC!
//    @State private var shouldScrollToBottom = false
    let currentUser: User
    let chat: TripChat
    let chatParticipants: [String: User]
//    var shouldScrollToBottom: Bool {
//        didSet {
//            print(shouldScrollToBottom)
//        }
//    }
    @Binding var messages: [ChatMessage]
    let onMessageShow: (ChatMessage, Bool) -> Void
    let onMediaButtonPress: () -> Void
    let onSendButtonPress: (String) -> Void

    init(currentUser: User,
         chat: TripChat,
         chatParticipants: [String: User],
//         shouldScrollToBottom: Binding<Bool>,
         messages: Binding<[ChatMessage]>,
         onMessageShow: @escaping (ChatMessage, Bool) -> Void,
         onMediaButtonPress: @escaping () -> Void,
         onSendButtonPress: @escaping (String) -> Void) {
        self.currentUser = currentUser
        self.chat = chat
        self.chatParticipants = chatParticipants
//        self._shouldScrollToBottom = shouldScrollToBottom
        self._messages = messages
        self.onMessageShow = onMessageShow
        self.onMediaButtonPress = onMediaButtonPress
        self.onSendButtonPress = onSendButtonPress
    }
    
    func makeUIViewController(context: Context) -> MessageSwiftUIVC {
        let messagesVC = MessageSwiftUIVC { index in
            if index >= 0 && index < messages.count && initialized {
//                print("onMessageShow - ", messages[index].text)
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
        Coordinator(currentUser: currentUser, chat: chat, chatParticipants: chatParticipants, messages: messages, onSendButtonPress: onSendButtonPress)
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

// MARK: - MessagesView.Coordinator + InputBarAccessoryViewDelegate

extension MessagesView.Coordinator: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    onSendButtonPress(text)
    inputBar.inputTextView.text = ""
  }

}

// MARK: - MessagesView.Coordinator + MessagesLayoutDelegate, MessagesDisplayDelegate

extension MessagesView.Coordinator: MessagesLayoutDelegate, MessagesDisplayDelegate {
    
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

final class MessageSwiftUIVC: MessagesViewController {
    
    private var scrollToBottomButton: UIButton?
    private var isScrollToBottomButtonVisible: Bool = false
    private var isUserDragging: Bool = false
    
    let onMessageAppear: (Int) -> Void
    let onMessageDisappear: (Int) -> Void
    
    init(onMessageAppear: @escaping (Int) -> Void, 
         onMessageDisappear: @escaping (Int) -> Void) {
        self.onMessageAppear = onMessageAppear
        self.onMessageDisappear = onMessageDisappear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollToBottomButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
        messagesCollectionView.scrollToLastItem(animated: false)
    }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
      if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
          layout.textMessageSizeCalculator.incomingAvatarPosition = .init(vertical: .messageTop)
          layout.textMessageSizeCalculator.avatarLeadingTrailingPadding = 12
          layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
      }
      showMessageTimestampOnSwipeLeft = true
  }
       
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        onMessageAppear(indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        onMessageDisappear(indexPath.section)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let lowestPoint = scrollView.contentSize.height - scrollView.bounds.height + scrollView.adjustedContentInset.bottom
        let difference = lowestPoint - scrollView.contentOffset.y
        let userScrolledABit = difference > 75 && isUserDragging
        var scrollViewIsScrolledToTop = false
        scrollViewIsScrolledToTop = scrollView.contentOffset.y < -95 && scrollView.contentSize.height > scrollView.bounds.height

        if userScrolledABit || scrollViewIsScrolledToTop {
            setScrollToBottomButton(visible: true)
        } else {
            setScrollToBottomButton(visible: false)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDragging(scrollView)
        isUserDragging = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        isUserDragging = false
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: willDecelerate)
        if !willDecelerate {
            isUserDragging = false
        }
    }
    
    private func addScrollToBottomButton() {
        let button = UIButton(type: .system)
        let buttonSide: CGFloat = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.opacity = 0
        // Applying Background Material
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false // Allows button to receive the touch events
        button.addSubview(blurEffectView)
        
        // Setting the Image with SFSymbol
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false // Allows button to receive the touch events
        let image = UIImage(systemName: "chevron.down")
        imageView.image = image
        blurEffectView.contentView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true

        // Making the Button Round
        button.layer.cornerRadius = buttonSide / 2 // assuming the button size is 50x50
        button.clipsToBounds = true

        // Inserting Button
        self.view.addSubview(button)
        
        // Applying Constraint
        button.widthAnchor.constraint(equalToConstant: buttonSide).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonSide).isActive = true
        button.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true

        // Adding Action
        button.addTarget(self, action: #selector(scrollToBottomButtonAction), for: .touchUpInside)
        scrollToBottomButton = button
    }
    
    @objc private func scrollToBottomButtonAction() {
        print("Scroll To Bottom Button Pressed")
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    
    private func setScrollToBottomButton(visible: Bool) {
        guard isScrollToBottomButtonVisible != visible else { return }
        isScrollToBottomButtonVisible = visible
        
        let opacity: Float = visible ? 1 : 0
        let isEnabled = visible ? true : false
        scrollToBottomButton?.isUserInteractionEnabled = isEnabled
        UIView.animate(withDuration: 0.2) {
            self.scrollToBottomButton?.layer.opacity = opacity
        }
    }
}
