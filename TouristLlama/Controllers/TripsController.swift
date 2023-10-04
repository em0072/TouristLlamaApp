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
    
    var myTripsStartTime: TimeInterval = 0
    var exploreTripsStartTime: TimeInterval = 0

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
        myTripsStartTime = Date().timeIntervalSince1970
        print("Starting Load My Trips", Date().timeIntervalSince1970)
        Task(priority: .userInitiated) {
            do {
                myTrips = try await tripsAPI.getMyTrips()
                subscribeToTripsUpdates()
                let finalTime = Date().timeIntervalSince1970
                print("Completed Load My Trips", finalTime, "It took ", finalTime - myTripsStartTime)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Explore Trips
    @MainActor
    func loadExploreTrips() {
        exploreTripsStartTime = Date().timeIntervalSince1970
        print("Starting Load Explore Trips", exploreTripsStartTime)
        Task(priority: .userInitiated) {
            do {
                exploreTrips = try await tripsAPI.getExploreTrips(searchTerm: "")
                subscribeToTripsUpdates()
                let finalTime = Date().timeIntervalSince1970
                print("Completed Load Explore Trips", finalTime, "It took ", finalTime - exploreTripsStartTime)
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func searchTrips(searchTerm: String, tripStyle: TripStyle? = nil, startDate: Date? = nil, endDate: Date? = nil) {
        Task(priority: .userInitiated) {
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
        exploreTripsStartTime = Date().timeIntervalSince1970
        print("Starting Load Explore Trips", exploreTripsStartTime)
        Task { [weak self] in
            guard let self else { return }
            do {
                async let myTrips = self.tripsAPI.getMyTrips()
                async let exploreTrips = self.tripsAPI.getExploreTrips(searchTerm: "")
                let trips = try await (myTrips, exploreTrips)
                self.myTrips = trips.0
                self.exploreTrips = trips.1
                self.subscribeToTripsUpdates()
                let finalTime = Date().timeIntervalSince1970
                print("Completed Load Explore Trips", finalTime, "It took ", finalTime - exploreTripsStartTime)
            } catch {
                print(error)
            }
        }
//        loadMyTrips()
//        loadExploreTrips()
    }
    
    func reloadTrips() {
        // Force lists with this trips to re-render
        myTrips = myTrips
        exploreTrips = exploreTrips
    }
    
    // MARK: Subscriptions
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
        guard myTrips != nil && exploreTrips != nil else { return }
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
    
    // MARK: - Trips Managment
    func create(trip: Trip) async throws {
        let newTrip = try await tripsAPI.create(trip)
        await updateTrips(with: newTrip)
    }

    func edit(trip: Trip) async throws {
        let editedTrip = try await tripsAPI.edit(trip: trip)
        await updateTrips(with: editedTrip)
    }
    
    func removeUserFromTrip(tripId: String, userId: String) async throws {
        try await tripsAPI.removeUser(tripId: tripId, userId: userId)
        await deleteUser(userId: userId, tripId: tripId)
    }
    
    func cancelInvite(tripId: String, userId: String) async throws {
        try await tripsAPI.cancelInvite(tripId: tripId, userId: userId)
        await deleteUserRequest(userId: userId, tripId: tripId)
    }

    func sendJoinInvite(tripId: String, userId: String) async throws -> TripRequest {
        let request = try await tripsAPI.sendJoinInvite(tripId: tripId, userId: userId)
        await updateTrips(with: request)
        return request
    }
    
    func answerTravelRequest(request: TripRequest, approved: Bool) async throws -> TripRequest {
        let updatedRequest = try await tripsAPI.answerTravelRequest(request: request, approved: approved)
        await updateTrips(with: updatedRequest)
        return updatedRequest
    }
    
    func answerTravelInvite(request: TripRequest, accepted: Bool) async throws -> TripRequest {
        let updatedRequest = try await tripsAPI.answerTravelInvite(request: request, accepted: accepted)
        await updateTrips(with: updatedRequest)
        return updatedRequest

    }

    func sendJoinRequest(tripId: String, message: String) async throws -> TripRequest {
        let request = try await tripsAPI.sendJoinRequest(tripId: tripId, message: message)
        await updateTrips(with: request)
        return request
    }

    func cancelJoinRequest(request: TripRequest) async throws {
        try await tripsAPI.cancelJoinRequest(request: request)
        await updateRequestStatus(request: request, status: .requestCancelled)
    }

    func leaveTrip(tripId: String) async throws {
        try await tripsAPI.leaveTrip(tripId: tripId)
        if let currentUser = userAPI.currentUser {
            await deleteUser(userId: currentUser.id, tripId: tripId)
        }
    }
    
    func deleteTrip(tripId: String) async throws {
        try await tripsAPI.deleteTrip(tripId: tripId)
        await deleteTrip(with: tripId)
    }

    func reportTrip(tripId: String, reason: String) async throws {
        try await tripsAPI.reportTrip(tripId: tripId, reason: reason)
    }
    
    // MARK: - Data Source Update
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
    
    @MainActor
    func updateTrips(with request: TripRequest) {
        if let myTripIndex = myTrips?.firstIndex(where: { $0.id == request.tripId }) {
            myTrips?[myTripIndex].upsert(tripRequest: request)
        }
        
        if let exploreTripIndex = exploreTrips?.firstIndex(where: { $0.id == request.tripId }) {
            exploreTrips?[exploreTripIndex].upsert(tripRequest: request)
        }
    }

    @MainActor
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
    
    @MainActor
    private func deleteUser(userId: String , tripId: String) {
        if let myTripIndex = myTrips?.firstIndex(where: { $0.id == tripId }),
           var tripToEdit = myTrips?[myTripIndex] {
            tripToEdit.delete(participantId: userId)
            updateTrips(with: tripToEdit)
        }
    }
    
    @MainActor
    private func deleteUserRequest(userId: String , tripId: String) {
        if let myTripIndex = myTrips?.firstIndex(where: { $0.id == tripId }),
           var tripToEdit = myTrips?[myTripIndex] {
            tripToEdit.deleteRequest(userId: userId)
            updateTrips(with: tripToEdit)
        }
    }
    
    @MainActor
    private func updateRequestStatus(request: TripRequest , status: TripRequestStatus) {
        if let myTripIndex = myTrips?.firstIndex(where: { $0.id == request.tripId }),
           var tripToEdit = myTrips?[myTripIndex] {
            var requestToUpdate = request
            requestToUpdate.status = status
            tripToEdit.upsert(tripRequest: requestToUpdate)
            updateTrips(with: tripToEdit)
        }
    }

}
