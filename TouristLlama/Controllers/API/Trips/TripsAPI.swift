//
//  TripsAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import SwiftUI
import Combine
import Dependencies

class TripsAPI {
    
    @Dependency(\.userAPI) var userAPI
    
    private let provider: TripsAPIProvider
    @Published var myTrips: [Trip] = []
    @Published var myTripsIsLoaded = false
    
    @Published var allTrips: [Trip] = []
    @Published var allTripsIsLoaded = false

    var publishers: [String: PassthroughSubject<Trip, Never>] = [:]
    var cancelebles = Set<AnyCancellable>()

    init(provider: TripsAPIProvider) {
        self.provider = provider
        updateMyTrips()
    }
    
    func subscribreToTripUpdates(with tripId: String) -> AnyPublisher<Trip, Never> {
        
        if let exictingPublisher = publishers[tripId] {
            return exictingPublisher.eraseToAnyPublisher()
        }
        let publisher = PassthroughSubject<Trip, Never>()
        publishers[tripId] = publisher
        provider.subscribeToTripUpdates(for: tripId) { [weak self] tripId in
            guard let self else { return }
            Task {
                do {
                    let trip = try await self.getTrip(for: tripId)
                    Task { @MainActor in
                        publisher.send(trip)
                    }
                } catch {
                    print("ERROR can't get trip with id \(tripId) - \(error)")
                }
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func subscribeOnTripDeletion(with tripId: String) {
        provider.subscribeToTripDeletion(for: tripId) { [weak self] tripId in
            self?.deleteTrip(with: tripId)
        }
    }
    
    func updateLastMessage(tripId: String, message: ChatMessage) {
        if let myTripIndex = myTrips.firstIndex(where: { $0.id == tripId }) {
            myTrips[myTripIndex].lastMessage = message
        }
    }
    
    func getTrip(for tripId: String) async throws -> Trip {
        try await provider.getTrip(for: tripId)
    }
    
    func create(trip: Trip) async throws {
        let newTrip = try await provider.create(trip: trip)
        addTripToMyTrips(newTrip)
    }
    
    func edit(trip: Trip) async throws -> Trip {
        let editedTrip = try await provider.editTrip(trip: trip)
        updateTrips(with: editedTrip)
        return editedTrip
    }
    
    func getExploreTrips(searchTerm: String, tripStyel: TripStyle? = nil, startDate: Date? = nil, endDate: Date? = nil) async throws {
        allTrips = try await provider.getExploreTrips(searchTerm: searchTerm, tripStyle: tripStyel, startDate: startDate, endDate: endDate)
        await subscribeToAllTripsUpdates()
    }
    
    func sendJoinRequest(tripId: String, message: String) async throws -> TripRequest {
        let request = try await provider.sendJoinRequest(tripId: tripId, message: message)
        updateTrips(with: request)
        return request
    }
    
    func cancelJoinRequest(request: TripRequest) async throws {
        try await provider.cancelJoinRequest(tripId: request.tripId)
        cancelRequest(request)
    }
    
    func answerTravelRequest(request: TripRequest, approved: Bool) async throws -> TripRequest {
        let updatedRequest = try await provider.answerTravelRequest(request: request, approved: approved)
        updateTrips(with: updatedRequest)
        return updatedRequest
    }
    
    func removeUser(tripId: String, userId: String) async throws {
        try await provider.removeUser(tripId: tripId, userId: userId)
    }
    
    func sendJoinInvite(tripId: String, userId: String) async throws -> TripRequest {
        let request = try await provider.sendJoinInvite(tripId: tripId, userId: userId)
        updateTrips(with: request)
        return request
    }
    
    func answerTravelInvite(request: TripRequest, accepted: Bool) async throws -> TripRequest {
        let updatedRequest = try await provider.answerTravelInvite(request: request, accepted: accepted)
        updateTrips(with: updatedRequest)
        return updatedRequest
    }
    
    func leaveTrip(tripId: String) async throws {
       try await provider.leaveTrip(tripId: tripId)
    }
    
    func deleteTrip(tripId: String) async throws {
       try await provider.deleteTrip(tripId: tripId)
    }

    func reportTrip(tripId: String, reason: String) async throws {
        try await provider.reportTrip(tripId: tripId, reason: reason)
    }
    

    private func updateMyTrips() {
        Task {
            do {
                myTrips = try await provider.getMyTrips()
                myTripsIsLoaded = true
                await subscribeToMyTripsUpdates()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    private func subscribeToMyTripsUpdates() {
        for trip in myTrips {
            subscribreToTripUpdates(with: trip.id)
                .sink { [weak self] updatedTrip in
                    self?.updateTrips(with: updatedTrip)
                }
                .store(in: &cancelebles)
            
            subscribeOnTripDeletion(with: trip.id)
        }
    }
    
    @MainActor
    private func subscribeToAllTripsUpdates() {
        for trip in allTrips {
            subscribreToTripUpdates(with: trip.id)
                .sink { [weak self] updatedTrip in
                    self?.updateTrips(with: updatedTrip)
                }
                .store(in: &cancelebles)
            
            subscribeOnTripDeletion(with: trip.id)
        }
    }
    
    private func cancelRequest(_ request: TripRequest) {
        if let myTripIndex = myTrips.firstIndex(where: { $0.id == request.tripId }) {
            myTrips[myTripIndex].delete(tripRequest: request)
        }

        if let allTripIndex = allTrips.firstIndex(where: { $0.id == request.tripId }) {
            allTrips[allTripIndex].delete(tripRequest: request)
        }

    }
    
    private func updateTrips(with request: TripRequest) {
        if let myTripIndex = myTrips.firstIndex(where: { $0.id == request.tripId }) {
            myTrips[myTripIndex].upsert(tripRequest: request)
        }

        if let allTripIndex = allTrips.firstIndex(where: { $0.id == request.tripId }) {
            allTrips[allTripIndex].upsert(tripRequest: request)
        }
    }
        
    private func addTripToMyTrips(_ trip: Trip) {
        myTrips.append(trip)
        myTrips.sort { $0.startDate < $1.startDate }
        myTrips.sort { $0.endDate < $1.endDate }
    }
    
    private func updateTrips(with trip: Trip) {
        updateMyTripsIfNeeded(with: trip)
        
        if let allTripIndex = allTrips.firstIndex(where: { $0.id == trip.id }) {
            allTrips[allTripIndex] = trip
        }
    }
    
    private func updateMyTripsIfNeeded(with trip: Trip) {
        //If user is a participant of the trip
        if trip.participants.contains(where: { $0.id == userAPI.currentUser?.id }) {
            // If trip is in MyTrips then update the trip
            if let myTripIndex = myTrips.firstIndex(where: { $0.id == trip.id }) {
                myTrips[myTripIndex] = trip
            } else { // If trip is not in MyTrips then add it
                addTripToMyTrips(trip)
            }
        } else { //If user is not a participant of the trip then delete it from MyTrips
            myTrips.removeAll(where: { $0.id == trip.id })
        }
    }
    
    private func deleteTrip(with tripId: String) {
        withAnimation {
            if let myTripIndex = myTrips.firstIndex(where: { $0.id == tripId }) {
                myTrips.remove(at: myTripIndex)
            }
            
            if let allTripIndex = allTrips.firstIndex(where: { $0.id == tripId }) {
                allTrips.remove(at: allTripIndex)
            }
        }
    }
    
}
