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
    @Dependency(\.chatAPI) var chatAPI
    @Dependency(\.tripsAPI) var tripAPI
    @Dependency(\.userDefaultsController) var userDefaultsController
    @Dependency(\.tripsController) var tripsController

    @Published var trip: Trip
    @Published var isDiscussionLoaded = false
//    @Published var isApplicationLetterFormShown = false
    @Published var shouldDismiss = false
    @Published var isMembersManagmentOpen = false
    @Published var selectedTab: TabSelection = .details {
        didSet {
            if selectedTab == .chats && isDiscussionLoaded {
                chatBadgeCount = 0
            }
        }
    }
    @Published var tripToEdit: Trip?
    @Published var chatBadgeCount: Int = 0
    
    convenience init(trip: Trip) {
        self.init(openState: .details(trip))
    }
    
    init(openState: TripOpenState) {
        switch openState {
        case .details(let trip):
            self.trip = trip
            
        case .members(let trip):
            self.trip = trip
            isMembersManagmentOpen = true
            
        case .chat(let trip):
            self.trip = trip
            selectedTab = .chats
        }
        
        super.init()

        getTripDiscussionIfNeeded()
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToUserUpdates()
        subscribeToTripUpdates()
    }
    
    private func subscribeToUserUpdates() {
        userAPI.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] currentUser in
                if currentUser == nil {
                    self?.shouldDismiss = true
                }
            }
            .store(in: &publishers)
    }
    
    
    private func subscribeToTripUpdates() {
        tripsController.$selectedTripState
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] tripState in
                guard let updatedTrip = tripState?.trip else { return }
                self?.updateTrip(with: updatedTrip)
            }
            .store(in: &publishers)
    }
    
    private func subscribeToChatUpdates() {
        guard let chatId = trip.chat?.id else { return }
        tripsController.subscribeToNewMessages(chatId: chatId) { [weak self] message in
            guard let self else { return }
            guard chatId == message.chatId else { return }
            self.tripChatViewModel.proccessNewMessage(message)
            if self.selectedTab == .details {
                self.chatBadgeCount += 1
            }
        }
    }
    
    lazy var tripDetailViewModel: TripDetailViewModel = {
        TripDetailViewModel(trip: trip)
    }()
    
    lazy var tripChatViewModel: TripChatViewModel = {
        TripChatViewModel()
    }()
    
    var isCurrentUserParticipantOfTrip: Bool {
        guard let currentUser = userAPI.currentUser else { return false}
        return trip.participants.contains(currentUser)
    }
    
    var tripChat: TripChat? {
        isDiscussionLoaded ? trip.chat : nil
    }
    
    func editTrip() {
        tripToEdit = trip
    }
    
    func updateTrip(with trip: Trip) {
        self.trip = trip
        tripDetailViewModel.updateTrip(updatedTrip: trip)
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
                let tripChat = try await chatAPI.getTripChat(tripId: trip.id)
                trip.chat = tripChat
                subscribeToChatUpdates()
                isDiscussionLoaded = true
                setChatBadgeIfNeeded()
                updateChat(tripChat)
            } catch {
                self.error = error
            }
        }
    }
    
    private func setChatBadgeIfNeeded() {
        guard let chat = trip.chat else { return }
        guard selectedTab != .chats  else {
            chatBadgeCount = 0
            return
        }
        let lastReadMessageId = userDefaultsController.getLastMessageIf(for: trip.id)
        if let lastReadMessage = chat.messages.first(where: { $0.id == lastReadMessageId }) {
            let unreadMessagesCount = chat.messages.filter( { $0.created > lastReadMessage.created } ).count
            chatBadgeCount = unreadMessagesCount
        } else {
            chatBadgeCount = chat.messages.count
        }
    }
    
    private func updateChat(_ tripChat: TripChat) {
        tripChatViewModel.updateChat(with: tripChat)
    }

}
