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
//    @Published var myTrips: [Trip] = []
//    @Published var myTripsIsLoaded = false
//
//    @Published var allTrips: [Trip] = []
//    @Published var allTripsIsLoaded = false

    var publishers: [String: PassthroughSubject<Trip, Never>] = [:]
    var cancelebles = Set<AnyCancellable>()

    init(provider: TripsAPIProvider) {
        self.provider = provider
//        updateMyTrips()
    }
    
    func subscribeToTripsUpdates(for trips: [Trip], onNewUpdate: @escaping (Trip) -> Void) {
        provider.subscribeToTripsUpdates(for: trips) { tripId in
            Task {
                do {
                    let trip = try await self.getTrip(for: tripId)
                    Task { @MainActor in
                        onNewUpdate(trip)
                    }
                } catch {
                    print("ERROR can't get trip with id \(tripId) - \(error)")
                }
            }
        }
    }
    
    func subscribeToTripsDeletion(for trips: [Trip], onDelete: @escaping (String) -> Void) {
        provider.subscribeToTripsDeletion(for: trips, onDelete: onDelete)
    }
    
//    func subscribreToTripUpdates(with tripId: String) -> AnyPublisher<Trip, Never> {
//
//        if let exictingPublisher = publishers[tripId] {
//            return exictingPublisher.eraseToAnyPublisher()
//        }
//        let publisher = PassthroughSubject<Trip, Never>()
//        publishers[tripId] = publisher
//        provider.subscribeToTripUpdates(for: tripId) { [weak self] tripId in
//            guard let self else { return }
//            Task {
//                do {
//                    let trip = try await self.getTrip(for: tripId)
//                    Task { @MainActor in
//                        publisher.send(trip)
//                    }
//                } catch {
//                    print("ERROR can't get trip with id \(tripId) - \(error)")
//                }
//            }
//        }
//
//        return publisher.eraseToAnyPublisher()
//    }
    
//    func subscribeOnTripDeletion(with tripId: String, onTripDelete: @escaping (String) -> Void) {
//        provider.subscribeToTripDeletion(for: tripId, onDelete: onTripDelete)
////        provider.subscribeToTripDeletion(for: tripId) { [weak self] tripId in
////            onTripDelete(tripId)
////        }
//    }
    
//    func updateLastMessage(tripId: String, message: ChatMessage) {
//        if let myTripIndex = myTrips.firstIndex(where: { $0.id == tripId }) {
//            myTrips[myTripIndex].lastMessage = message
//        }
//    }
    
    func getMyTrips() async throws -> [Trip] {
        try await provider.getMyTrips()
    }
    
    func getTrip(for tripId: String) async throws -> Trip {
        try await provider.getTrip(for: tripId)
    }
    
    func create(_ trip: Trip) async throws -> Trip {
        try await provider.create(trip: trip)
    }
    
    func edit(trip: Trip) async throws -> Trip {
        try await provider.editTrip(trip: trip)
    }
    
    func getExploreTrips(searchTerm: String, tripStyle: TripStyle? = nil, startDate: Date? = nil, endDate: Date? = nil) async throws -> [Trip] {
        try await provider.getExploreTrips(searchTerm: searchTerm, tripStyle: tripStyle, startDate: startDate, endDate: endDate)
//        await subscribeToAllTripsUpdates()
    }
    
    func sendJoinRequest(tripId: String, message: String) async throws -> TripRequest {
        try await provider.sendJoinRequest(tripId: tripId, message: message)
    }
    
    func cancelJoinRequest(request: TripRequest) async throws {
        try await provider.cancelJoinRequest(tripId: request.tripId)
    }
    
    func answerTravelRequest(request: TripRequest, approved: Bool) async throws -> TripRequest {
        try await provider.answerTravelRequest(request: request, approved: approved)
    }
    
    func removeUser(tripId: String, userId: String) async throws {
        try await provider.removeUser(tripId: tripId, userId: userId)
    }
    
    func cancelInvite(tripId: String, userId: String) async throws {
        try await provider.cancelInvite(tripId: tripId, userId: userId)
    }
    
    func sendJoinInvite(tripId: String, userId: String) async throws -> TripRequest {
        try await provider.sendJoinInvite(tripId: tripId, userId: userId)
    }
    
    func answerTravelInvite(request: TripRequest, accepted: Bool) async throws -> TripRequest {
        try await provider.answerTravelInvite(request: request, accepted: accepted)
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
    

//    private func updateMyTrips() {
//        Task {
//            do {
//                myTrips = try await provider.getMyTrips()
//                myTripsIsLoaded = true
//                await subscribeToMyTripsUpdates()
//            } catch {
//                print(error)
//            }
//        }
//    }
    
//    @MainActor
//    private func subscribeToMyTripsUpdates() {
//        for trip in myTrips {
//            subscribreToTripUpdates(with: trip.id)
//                .sink { [weak self] updatedTrip in
//                    self?.updateTrips(with: updatedTrip)
//                }
//                .store(in: &cancelebles)
//
//            subscribeOnTripDeletion(with: trip.id)
//        }
//    }
    
//    @MainActor
//    private func subscribeToAllTripsUpdates() {
//        for trip in allTrips {
//            subscribreToTripUpdates(with: trip.id)
//                .sink { [weak self] updatedTrip in
//                    self?.updateTrips(with: updatedTrip)
//                }
//                .store(in: &cancelebles)
//            
////            subscribeOnTripDeletion(with: trip.id)
//        }
//    }
    
//    private func cancelRequest(_ request: TripRequest) {
//        if let myTripIndex = myTrips.firstIndex(where: { $0.id == request.tripId }) {
//            myTrips[myTripIndex].delete(tripRequest: request)
//        }
//
//        if let allTripIndex = allTrips.firstIndex(where: { $0.id == request.tripId }) {
//            allTrips[allTripIndex].delete(tripRequest: request)
//        }
//
//    }
//    
//    private func updateTrips(with request: TripRequest) {
//        if let myTripIndex = myTrips.firstIndex(where: { $0.id == request.tripId }) {
//            myTrips[myTripIndex].upsert(tripRequest: request)
//        }
//
//        if let allTripIndex = allTrips.firstIndex(where: { $0.id == request.tripId }) {
//            allTrips[allTripIndex].upsert(tripRequest: request)
//        }
//    }
//        
//    private func addTripToMyTrips(_ trip: Trip) {
//        myTrips.append(trip)
//        myTrips.sort { $0.startDate < $1.startDate }
//        myTrips.sort { $0.endDate < $1.endDate }
//    }
//    
//    private func updateTrips(with trip: Trip) {
//        updateMyTripsIfNeeded(with: trip)
//        
//        if let allTripIndex = allTrips.firstIndex(where: { $0.id == trip.id }) {
//            allTrips[allTripIndex] = trip
//        }
//    }
//    
//    private func updateMyTripsIfNeeded(with trip: Trip) {
//        //If user is a participant of the trip
//        if trip.participants.contains(where: { $0.id == userAPI.currentUser?.id }) {
//            // If trip is in MyTrips then update the trip
//            if let myTripIndex = myTrips.firstIndex(where: { $0.id == trip.id }) {
//                myTrips[myTripIndex] = trip
//            } else { // If trip is not in MyTrips then add it
//                addTripToMyTrips(trip)
//            }
//        } else { //If user is not a participant of the trip then delete it from MyTrips
//            myTrips.removeAll(where: { $0.id == trip.id })
//        }
//    }
//    
//    private func deleteTrip(with tripId: String) {
//        withAnimation {
//            if let myTripIndex = myTrips.firstIndex(where: { $0.id == tripId }) {
//                myTrips.remove(at: myTripIndex)
//            }
//            
//            if let allTripIndex = allTrips.firstIndex(where: { $0.id == tripId }) {
//                allTrips.remove(at: allTripIndex)
//            }
//        }
//    }
    
}
