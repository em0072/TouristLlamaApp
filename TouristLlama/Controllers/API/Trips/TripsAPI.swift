//
//  TripsAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation
import Combine

class TripsAPI {
    
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
        }
    }
    
    private func cancelRequest(_ request: TripRequest) {
        for i in 0..<myTrips.count {
            myTrips[i].delete(tripRequest: request)
        }

        for i in 0..<allTrips.count {
            allTrips[i].delete(tripRequest: request)
        }
    }
    
    private func updateTrips(with tripRequest: TripRequest) {
        for i in 0..<myTrips.count {
            let trip = myTrips[i]
            if trip.id == tripRequest.tripId {
                myTrips[i].upsert(tripRequest: tripRequest)
            }
        }
        for i in 0..<allTrips.count {
            let trip = allTrips[i]
            if trip.id == tripRequest.tripId {
                allTrips[i].upsert(tripRequest: tripRequest)
            }
        }
    }
        
    private func addTripToMyTrips(_ trip: Trip) {
        myTrips.append(trip)
        myTrips.sort { $0.startDate < $1.startDate }
        myTrips.sort { $0.endDate < $1.endDate }
    }
    
    private func updateTrips(with trip: Trip) {
        if let myTripIndex = myTrips.firstIndex(where: { $0.id == trip.id }) {
            myTrips[myTripIndex] = trip
        }
        
        if let allTripIndex = allTrips.firstIndex(where: { $0.id == trip.id }) {
            allTrips[allTripIndex] = trip
        }

    }
    
    private func addMyTripsListner() {
        
    }

}
