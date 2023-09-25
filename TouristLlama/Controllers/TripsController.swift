//
//  TripsController.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/09/2023.
//

import SwiftUI
import Dependencies
import Combine
import AspirinShot

class TripsController: ObservableObject {
        
    @Dependency(\.tripsAPI) var tripsAPI
    @Dependency(\.chatAPI) var chatAPI
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.userDefaultsController) var userDefaultsController

    @Published var myTrips: [Trip]?
    @Published var exploreTrips: [Trip]?
    var allTrips: [Trip] {
        let myTrips = myTrips ?? []
        let exploreTrips = exploreTrips ?? []
        let allTrips = Set(myTrips + exploreTrips)
        return Array(allTrips)
    }
    @Published var selectedTripState: TripOpenState?

    private var messagePublishers = Set<AnyCancellable>()
    private var messagePublisher: PassthroughSubject<ChatMessage, Never>?

    init() {
        Task {
            await loadTrips()
        }
    }
    
    // MARK: - My Trips
    
    @MainActor
    private func loadMyTrips() {
        Task {
            do {
                myTrips = try await tripsAPI.getMyTrips()
                subscribeToTripsUpdates()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Explore Trips
    @MainActor
    func loadExploreTrips() {
        Task {
            do {
                exploreTrips = try await tripsAPI.getExploreTrips(searchTerm: "")
                subscribeToTripsUpdates()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func searchTrips(searchTerm: String, tripStyle: TripStyle? = nil, startDate: Date? = nil, endDate: Date? = nil) {
        Task {
            do {
                exploreTrips = try await tripsAPI.getExploreTrips(searchTerm: searchTerm, tripStyle: tripStyle, startDate: startDate, endDate: endDate)
                subscribeToTripsUpdates()
            } catch {
                print(error)
            }
        }

    }

    // MARK: - Shared
    func open(tripOpenState: TripOpenState) {
        selectedTripState = tripOpenState
    }
    
    func getTrip(tripId: String) async throws -> Trip {
        let trip = try await tripsAPI.getTrip(for: tripId)
        await updateTrips(with: trip)
        return trip
    }
    
    @MainActor
    func loadTrips() {
        loadMyTrips()
        loadExploreTrips()
    }
    
    func reloadTrips() {
        // Force lists with this trips to re-render
        myTrips = myTrips
        exploreTrips = exploreTrips
    }
    
    func subscribeToNewMessages(chatId: String, onNewMessage: @escaping (ChatMessage) -> Void) {
        messagePublisher = PassthroughSubject<ChatMessage, Never>()
        
        messagePublisher?
            .filter({ $0.chatId == chatId })
            .sink { message in
                onNewMessage(message)
            }
            .store(in: &messagePublishers)
    }
    
    @MainActor
    private func subscribeToTripsUpdates() {
        tripsAPI.subscribeToTripsUpdates(for: allTrips) { [weak self] updatedTrip in
            self?.updateTrips(with: updatedTrip)
        }
        
        tripsAPI.subscribeToTripsDeletion(for: allTrips) { [weak self] deletedTripId in
            self?.deleteTrip(with: deletedTripId)
        }
        
        tripsAPI.subscribeToTripsDeletion(for: allTrips) { [weak self] deletedTripId in
            self?.deleteTrip(with: deletedTripId)
        }

        if let myTrips {
            chatAPI.subscribeToChatUpdates(for: myTrips.compactMap({ $0.chat?.id })) { [weak self] message in
                self?.onNewMessage(message)
            }
        }
    }
    
    @MainActor
    func updateTrips(with updatedTrip: Trip?) {
        guard let updatedTrip else { return }
        if let myTrips {
            let isParticipantOfTrip = updatedTrip.participants.contains(where: { userAPI.currentUser?.id == $0.id })
            if let myTripIndex = myTrips.firstIndex(where: { $0.id == updatedTrip.id }) {
                if isParticipantOfTrip {
                    self.myTrips?[myTripIndex] = updatedTrip
                }
                if !isParticipantOfTrip {
                    self.myTrips?.remove(at: myTripIndex)
                }
            } else if isParticipantOfTrip {
                self.myTrips?.append(updatedTrip)
            }
        }
                
        if let exploreTrips, let exploreTripIndex = exploreTrips.firstIndex(where: { $0.id == updatedTrip.id }) {
            self.exploreTrips?[exploreTripIndex] = updatedTrip
        }
        
        if selectedTripState?.id == updatedTrip.id {
            selectedTripState?.updateTrip(newTrip: updatedTrip)
        }
        subscribeToTripsUpdates()
    }
        
    private func deleteTrip(with tripId: String) {
        if selectedTripState?.id == tripId {
            selectedTripState = nil
        }
        
        if let myTrips, let myTripIndex = myTrips.firstIndex(where: { $0.id == tripId }) {
            self.myTrips?.remove(at: myTripIndex)
        }
                
        if let exploreTrips, let exploreTripIndex = exploreTrips.firstIndex(where: { $0.id == tripId }) {
            self.exploreTrips?.remove(at: exploreTripIndex)
        }
    }

    private func onNewMessage(_ message: ChatMessage) {
        if let myTripIndex = myTrips?.firstIndex(where: { $0.chat?.id == message.chatId }) {
            myTrips?[myTripIndex].lastMessage = message
        }
        
        if let exploreTripIndex = exploreTrips?.firstIndex(where: { $0.chat?.id == message.chatId }) {
            exploreTrips?[exploreTripIndex].lastMessage = message
        }

        messagePublisher?.send(message)
    }
    
    
    
}
