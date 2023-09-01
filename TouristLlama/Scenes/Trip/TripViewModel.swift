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

    @Published var trip: Trip
    @Published var isDiscussionLoaded = false
    @Published var isApplicationLetterFormShown = false
    @Published var shouldDismiss = false
    @Published var isMembersManagmentOpen = false
    @Published var selectedTab: TabSelection = .details {
        didSet {
            if selectedTab == .chats {
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
        tripAPI.subscribreToTripUpdates(with: trip.id)
            .sink(receiveValue: { [weak self] updatedTrip in
                self?.trip = updatedTrip
                self?.getTripDiscussionIfNeeded()
            })
            .store(in: &publishers)
    }
    
    var isCurrentUserParticipantOfTrip: Bool {
        guard let currentUser = userAPI.currentUser else { return false}
        return trip.participants.contains(currentUser)
    }
    
    var nonParticipantTripRequest: TripRequest? {
        guard !isCurrentUserParticipantOfTrip else { return nil }
        return trip.requests.first
    }
    
    func editTrip() {
        tripToEdit = trip
    }
    
    func updateTrip(with trip: Trip) {
        self.trip = trip
        getTripDiscussionIfNeeded()
    }
    
    func joinButtonAction() {
        isApplicationLetterFormShown = true
    }
    
    func joinRequestSend(message: String) {
        loadingState = .loading
        Task {
            do {
                let tripRequest = try await tripAPI.sendJoinRequest(tripId: trip.id, message: message)
                trip.upsert(tripRequest: tripRequest)
                isApplicationLetterFormShown = false
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func cancelJoinRequest(_ request: TripRequest) {
        Task {
            do {
                loadingState = .loading
                try await tripAPI.cancelJoinRequest(request: request)
                trip.delete(tripRequest: request)
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func acceptInvite(_ request: TripRequest) {
        loadingState = .loading
        Task {
            do {
                let tripRequest = try await tripAPI.answerTravelInvite(request: request, accepted: true)
                trip.upsert(tripRequest: tripRequest)
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func rejectInvite(_ request: TripRequest) {
        loadingState = .loading
        Task {
            do {
                let tripRequest = try await tripAPI.answerTravelInvite(request: request, accepted: false)
                trip.upsert(tripRequest: tripRequest)
            } catch {
                self.error = error
            }
            loadingState = .none
        }
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
                setChatBadgeIfNeeded()
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
        var unreadMessages = 0
        let lastReadMessageId = userDefaultsController.getLastMessageIf(for: trip.id)
        var foundLastReadMessage = false
        for message in chat.messages {
            if foundLastReadMessage {
                unreadMessages += 1
            }
            if message.id == lastReadMessageId {
                foundLastReadMessage = true
            }
        }
        chatBadgeCount = unreadMessages
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
    

    
}
