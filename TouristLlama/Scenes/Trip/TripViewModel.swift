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
    
    init(trip: Trip) {
        self.trip = trip
        super.init()
        
        getTripDiscussionIfNeeded()
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
    }
    
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
    

    
}
