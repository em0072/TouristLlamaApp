//
//  TripViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import Foundation
import Dependencies
import SwiftSDK

class TripViewModel: ViewModel {
    
    enum TabSelection {
        case details
        case chats
    }

    @Dependency(\.userAPI) var userAPI
//    @Dependency(\.tripsAPI) var tripsAPI
    @Dependency(\.chatAPI) var chatAPI

    @Published var trip: Trip
    @Published var isDiscussionLoaded = false
    @Published var selectedTab: TabSelection = .details {
        didSet {
            if selectedTab == .chats {
                chatBadgeCount = 0
            }
        }
    }
    @Published var tripToEdit: Trip?
    @Published var chatBadgeCount: Int = 0
    
//    @Published var chatMessageText: String = ""
//    private let channel: Channel
//    private var channelListner: RTSubscription?
    
    init(trip: Trip) {
        self.trip = trip
//        channel = Backendless.shared.messaging.subscribe(channelName: "\(trip.name)")
        super.init()
        
        getTripDiscussionIfNeeded()
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
    }

    //    var tripImageURL: URL {
//        trip.photo.large
//    }
    
//    var tripDatesText: String {
//        guard let start = DateHandler().dateToString(trip.startDate),
//              let end = DateHandler().dateToString(trip.endDate) else { return "" }
//        return "\(start) - \(end)"
//    }
//    
//    var numberOfNightsText: String {
//        guard let num = Calendar(identifier: .gregorian).numberOfDaysBetween(trip.startDate, and: trip.endDate) else {
//            return ""
//        }
//        return String.Trip.numberOfNights(num)
//    }
    
//    func isCurrentUser(_ user: User) -> Bool {
//        return userAPI.currentUser?.id == user.id
//    }
    
    var isCurrentUserParticipantOfTrip: Bool {
        guard let currentUser = userAPI.currentUser else { return false}
        return trip.participants.contains(currentUser)
    }
    
    func editTrip() {
        tripToEdit = trip
    }
    
    func updateTrip(with trip: Trip) {
        self.trip = trip
        getTripDiscussionIfNeeded()
    }
    
    private func getTripDiscussionIfNeeded() {
        if isCurrentUserParticipantOfTrip {
            getTripDiscussion()
        }
    }
    
    private func getTripDiscussion() {
        Task {
            do {
                let discussion = try await chatAPI.getTripChat(for: trip.id)
                trip.chat = discussion
                subscribeToChatUpdates()
                isDiscussionLoaded = true
            } catch {
                self.error = error
            }
        }
    }
    
    private func subscribeToChatUpdates() {
        guard let chatId = trip.chat?.id else { return }
        chatAPI.subscribeToChatUpdates(for: chatId)
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                if self.selectedTab == .details {
                    self.chatBadgeCount += 1
                }
            }
            .store(in: &publishers)
    }
    

//    @MainActor
//    private func insertMessageIfNeeded(_ message: ChatMessage) {
//        if userAPI.currentUser?.id != message.ownerId {
//            trip.chat?.messages.append(message)
//        } else if let messageIndex = trip.chat?.messages.firstIndex(of: message) {
//            trip.chat?.messages[messageIndex].status = .sent
//        } else {
//            trip.chat?.messages.append(message)
//        }
//    }
    
//    func isFirstFormAuthor(message: ChatMessage) -> Bool {
//        guard let messages = trip.chat?.messages,
//              let messageIndex = messages.firstIndex(of: message)
//        else { return false }
//        let previousMessageIndex = messageIndex - 1
//        
//        guard previousMessageIndex >= 0 else {
//            return true
//        }
//        let previousMessage = messages[previousMessageIndex]
//        if previousMessage.ownerId == message.ownerId {
//            return false
//        } else {
//            return true
//        }
//    }
    
//    func isOutgoing(message: ChatMessage) -> Bool {
//        return userAPI.currentUser?.id == message.ownerId
//    }
//    
//    func sendChatMessage() {
//        guard let chatId = trip.chat?.id else {
//            self.error = CustomError(text: "Couldn't determin chat Id")
//            return
//        }
//        guard !chatMessageText.isEmpty else {
//            self.error = CustomError(text: "Chat Message is empty")
//            return
//        }
//        let message = ChatMessage(chatId: chatId, text: chatMessageText, ownerId: userAPI.currentUser?.id ?? "")
//        chatMessageText.removeAll()
//        insertMessageIfNeeded(message)
//        Task {
//            do {
//                try await chatAPI.sendChatMessage(message: message)
//            } catch {
//                markMessageAsNotSent(message: message)
//                self.error = error
//            }
//        }
//    }
    
//    func resendChatMessage(message: ChatMessage) {
//        guard let messageIndex = trip.chat?.messages.firstIndex(of: message) else {
//            self.error = CustomError(text: "Can't resend the message")
//            return
//        }
//        trip.chat?.messages[messageIndex].status = .sending
//        Task {
//            do {
//                try await chatAPI.sendChatMessage(message: message)
//            } catch {
//                markMessageAsNotSent(message: message)
//                self.error = error
//            }
//        }
//    }
    
//    @MainActor
//    func markMessageAsNotSent(message: ChatMessage) {
//        if let messageIndex = trip.chat?.messages.firstIndex(of: message) {
//            trip.chat?.messages[messageIndex].status = .error
//        }
//    }
    
}
