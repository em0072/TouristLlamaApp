//
//  TripsAPIProvider.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation
import Combine

protocol TripsAPIProvider {
    func create(trip: Trip) async throws -> Trip
    func getMyTrips() async throws -> [Trip]
    func editTrip(trip: Trip) async throws -> Trip
    func getExploreTrips(searchTerm: String, tripStyle: TripStyle?, startDate: Date?, endDate: Date?) async throws -> [Trip]
    func subscribeToTripUpdates(for tripId: String, onNewUpdate: @escaping (String) -> Void)
    func subscribeToTripDeletion(for tripId: String, onDelete: @escaping (String) -> Void)
    func sendJoinRequest(tripId: String, message: String) async throws -> TripRequest
    func cancelJoinRequest(tripId: String) async throws
    func answerTravelRequest(request: TripRequest, approved: Bool) async throws -> TripRequest
    func getTrip(for tripId: String) async throws -> Trip
    func removeUser(tripId: String, userId: String) async throws
    func cancelInvite(tripId: String, userId: String) async throws
    func sendJoinInvite(tripId: String, userId: String) async throws -> TripRequest
    func answerTravelInvite(request: TripRequest, accepted: Bool) async throws -> TripRequest
    func leaveTrip(tripId: String) async throws
    func deleteTrip(tripId: String) async throws
    func reportTrip(tripId: String, reason: String) async throws 
}
