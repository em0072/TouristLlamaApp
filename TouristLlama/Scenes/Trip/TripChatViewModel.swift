//
//  TripChatViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import SwiftUI
import Dependencies
import PhotosUI
import Kingfisher

@MainActor
class TripChatViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.chatAPI) var chatAPI
    @Dependency(\.userDefaultsController) var userDefaultsController
    
    enum ImageState {
        case empty
        case loading(Progress)
        case failure(Error)
        case success(UIImage)
    }

    @Published var chat: TripChat? {
        didSet {
            if oldValue != chat {
                mapMessages()
            }
        }
    }
    @Published var messages: [ChatMessage] = []
//    @Published var chatMessageText: String = ""
    @Published var isMediaPickerSheetPresented: Bool = false
    @Published var isCameraOpen: Bool = false
    @Published var isPhotoLibraryOpen: Bool = false
    
    @Published var cameraImageToSend: UIImage?
    @Published var imageState: ImageState = .empty
    @Published var photoLibraryImagesToSend: PhotosPickerItem? {
        didSet {
            if let photoLibraryImagesToSend {
                let progress = loadTransferable(from: photoLibraryImagesToSend)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    @Published var shouldShowScrollButton: Bool = false
    
    @Published var chatParticipants = [String: User]()
    var pageOffset: Int = 1
    var canDownloadMoreMessages = false
    
    private var lastReadMessage: ChatMessage? {
        didSet {
            saveLastMessage()
        }
    }
    
    override init() {
        super.init()
        subscribeToImages()
    }
        
    private func setViewModelState() {
        self.state = chat == nil ? .loading : .content
    }
    
    private func subscribeToImages() {
        $imageState
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .empty:
                    self.loadingState = .none
                case .loading:
                    self.loadingState = .loading
                case .failure(let error):
                    self.loadingState = .error(error)
                case .success(let uiImage):
                    self.loadingState = .none
                    Task {
                        await self.sendChatMessage(image: uiImage)
                    }
                }
            }
            .store(in: &publishers)
    }
        
    func isMessageFromCurrentUser(_ message: ChatMessage) -> Bool {
        message.ownerId == userAPI.currentUser?.id
    }
    
    func isTitleMessage(_ message: ChatMessage) -> Bool {
        let messageId = message.id
        guard let index = messages.firstIndex(where: { $0.id == messageId }) else { return false }
        if index == 0 { return true }
        let previousIndex = index - 1
        let previousMessage = messages[previousIndex]
        if previousMessage.type == .info { return true }
        if previousMessage.ownerId == message.ownerId { return false }
        return true
    }
    
    func markEndOfChat(isEnd: Bool) {
        if isEnd {
            guard shouldShowScrollButton else { return }
            shouldShowScrollButton = false
        } else {
            guard !shouldShowScrollButton else { return }
            shouldShowScrollButton = true
        }
    }
    
    func messageAppeared(_ message: ChatMessage) {
        markAsRead(message)
        if message.id == messages.first?.id && canDownloadMoreMessages {
            downloadOlderMessages()
            canDownloadMoreMessages = false
        }
    }
        
    func updateChat(with chat: TripChat?) {
        if chat != self.chat {
            self.chat = chat
        }
        self.state = chat == nil ? .loading : .content
    }
    
    func proccessNewMessage(_ message: ChatMessage) {
//        guard message.author != self.userAPI.currentUser else { return }
        self.insertMessageIfNeeded(message)
    }

    func resend(message: ChatMessage) {
        guard let messageIndex = messages.firstIndex(of: message) else {
            self.error = CustomError(text: "Can't resend the message")
            return
        }
        messages[messageIndex].status = .sending
        Task {
            do {
                let sentMessage = try await chatAPI.sendChatMessage(message: message)
                insertMessageIfNeeded(sentMessage)
            } catch {
                markMessageAsNotSent(messageId: message.id)
            }
        }
    }

    func sendChatMessage(chatMessageText: String) {
        guard let chatId = chat?.id else {
            self.error = CustomError(text: "Couldn't determin chat Id")
            return
        }
        guard let currentUser = userAPI.currentUser else {
            self.error = CustomError(text: "Current User is not found - can't send the message")
            return
        }
        guard !chatMessageText.isEmpty else { return }
        Task {
            let message = ChatMessage(chatId: chatId, text: chatMessageText, author: currentUser)
            insertMessageIfNeeded(message)
            markAsRead(message)
            Task {
                do {
                    let sentMessage = try await chatAPI.sendChatMessage(message: message)
                    self.insertMessageIfNeeded(sentMessage)
                } catch {
                    markMessageAsNotSent(messageId: message.id)
                }
            }
        }
    }
    
    func sendChatMessage(image: UIImage) async {
        guard let chatId = chat?.id else {
            self.error = CustomError(text: "Couldn't determin chat Id")
            return
        }
        guard let currentUser = userAPI.currentUser else {
            self.error = CustomError(text: "Current User is not found - can't send the message")
            return
        }
        guard let imageId = photoLibraryImagesToSend?.itemIdentifier else {
            self.error = CustomError(text: "Can't identify the image")
            return
        }
//        Task {
        do {
            var mediaItem = ChatMessageMediaItem(image: image)
            var message = ChatMessage(chatId: chatId, image: mediaItem, author: currentUser)
            insertMessageIfNeeded(message)
            markAsRead(message)
            
            let urlString = try await chatAPI.uploadImage(id: imageId, chatId: chatId, image: image)
            mediaItem = ChatMessageMediaItem(url: URL(string: urlString), image: image)
            message.image = mediaItem
            ImageCache.default.store(image, forKey: urlString)
//            Task {
                do {
                    var sentMessage = try await chatAPI.sendChatMessage(message: message)
                    sentMessage.image?.image = image
                    self.insertMessageIfNeeded(sentMessage)
                } catch {
                    markMessageAsNotSent(messageId: message.id)
                }
//            }
        } catch {
            self.error = CustomError(text: error.localizedDescription)
        }
    }
        
    func markAsRead(_ message: ChatMessage) {
        guard message.type != .newMessages else { return }
        if let lastReadMessage {
            if message.created > lastReadMessage.created {
                self.lastReadMessage = message
                print("LAST READ MESSAGE UPDATED - \(message.text)")
            }
        } else {
            lastReadMessage = message
            print("LAST READ MESSAGE SET - \(message.text)")
        }
    }
    
    func downloadOlderMessages() {
        print("downloadOlderMessages TRIGGERED")
        guard let chat, canDownloadMoreMessages else { return }
        Task {
            do {
                let chat = try await chatAPI.getTripChat(tripId: chat.tripId, pageOffset: pageOffset)
                let messages = chat.messages
                canDownloadMoreMessages = messages.count >= chatAPI.pageSize
                addOlderMessages(messages)
                pageOffset += 1
            } catch {
                self.error = error
            }
        }
    }
    
    func mediaButtonAction() {
        isMediaPickerSheetPresented = true
    }
    
    func cameraButtonAction() {
        isCameraOpen = true
    }
    
    func photoLibraryButtonAction() {
        isPhotoLibraryOpen = true
    }
    
//    func prepareForScreenshot(isInScreenshot: Bool) {
//#if DEBUG
//        if isInScreenshot {
//            state = .content
//        }
//#endif
//    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ChatMessageMediaItem.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.photoLibraryImagesToSend else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let chatImage):
                    if let image = chatImage?.image {
                        self.imageState = .success(image)
                    } else {
                        self.imageState = .empty
                    }
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }


    private func mapMessages() {
        setViewModelState()
        guard let chat else { return }
        var messages = [ChatMessage]()
        let lastReadMessageId = userDefaultsController.getLastMessageId(for: chat.tripId)
        for (i, message) in chat.messages.enumerated() {
            var message = message
            // Collect all chat users
            collectUser(from: message)
            var position = determineMessagePosition(for: message, allMessages: chat.messages, at: i)
            position.reverse()
            message.position = position
            
            if message.id == lastReadMessageId {
                lastReadMessage = message
//                if !messages.isEmpty && chat.messages.first?.ownerId != userAPI.currentUser?.id {
//                    messages.insert(.newMessages, at: 0)
//                }
            }
            
            messages.insert(message, at: 0)
        }
        self.messages = messages
        
        canDownloadMoreMessages = messages.count == chatAPI.pageSize
    }
    
    private func saveLastMessage() {
        if let lastReadMessage, let chat {
            userDefaultsController.saveLast(messageId: lastReadMessage.id, for: chat.tripId)
        }
    }
    
    private func collectUser(from message: ChatMessage) {
        let author = message.author
        
        if chatParticipants[author.id] == nil {
            chatParticipants[author.id] = author
        }
    }
    
    private func filterUserMessage(_ message: ChatMessage?) -> ChatMessage? {
        guard let message else { return nil }
        if message.type.isUser {
            return message
        } else {
            return nil
        }
    }
    
    private func determineMessagePosition(for message: ChatMessage, allMessages: [ChatMessage]?, at index: Int) -> ChatMessage.MessagePosition {
        let previousMessage = filterUserMessage(allMessages?.previous(from: index))
        let nextMessage = filterUserMessage(allMessages?.next(from: index))

        if let previousMessage, let nextMessage {
            if message.ownerId == previousMessage.ownerId && message.ownerId == nextMessage.ownerId {
                return .middle
            } else if message.ownerId == previousMessage.ownerId && message.ownerId != nextMessage.ownerId {
                return .last
            } else if message.ownerId != previousMessage.ownerId && message.ownerId == nextMessage.ownerId{
                return .first
            } else {
                return .only
            }
        } else if let previousMessage, nextMessage == nil {
            if message.ownerId == previousMessage.ownerId {
                return .last
            } else {
                return .only
            }
        } else if let nextMessage, previousMessage == nil {
            if message.ownerId == nextMessage.ownerId {
                return .first
            } else {
                return .only
            }
        } else {
            return .only
        }
    }
    
    private func addOlderMessages(_ olderMessages: [ChatMessage]) {
        var messages = [ChatMessage]()
        for (i, message) in olderMessages.enumerated() {
            var message = message
            // Collect all chat users
            collectUser(from: message)
            var position = determineMessagePosition(for: message, allMessages: olderMessages, at: i)
            position.reverse()
            message.position = position
            
//            if message.id == lastReadMessageId {
//                lastReadMessage = message
//                if !messages.isEmpty && chat.messages.first?.ownerId != userAPI.currentUser?.id {
//                    messages.insert(.newMessages, at: 0)
//                }
//            }
            
            messages.insert(message, at: 0)
        }

        self.messages.insert(contentsOf: messages, at: 0)
    }
    
    private func markMessageAsNotSent(messageId: String) {
        if let messageIndex = messages.firstIndex(where: { $0.id == messageId }) {
                messages[messageIndex].status = .error
            }
        }
    
    private func markMessageAsSent(messageId: String) {
        if let messageIndex = messages.firstIndex(where: { $0.id == messageId }) {
                messages[messageIndex].status = .sent
            }
        }

    @MainActor
    private func insertMessageIfNeeded(_ message: ChatMessage) {
        var messageToInsert = message
        
        if let messageIndex = messages.firstIndex(where: { $0.id == message.id}) {
            let position = determineMessagePosition(for: messageToInsert, allMessages: messages, at: messageIndex)
            messageToInsert.position = position
            messages[messageIndex] = messageToInsert
        } else {
            // Determine Position
            let position = determineMessagePosition(for: messageToInsert, allMessages: messages, at: messages.count)
            messageToInsert.position = position
            // Append Message
            messages.append(messageToInsert)
            // Fix position of prevoius message
            let previousMessageIndex = messages.count - 2
            if let prevoiusMessage = messages.item(at: previousMessageIndex) {
                let previousMessagePosition = determineMessagePosition(for: prevoiusMessage, allMessages: messages, at: previousMessageIndex)
                messages[previousMessageIndex].position = previousMessagePosition
            }
        }
    }
    
}
