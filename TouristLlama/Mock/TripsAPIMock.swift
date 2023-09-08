//
//  TripAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation

class TripsAPIMock: TripsAPIProvider {
    
    func getMyTrips() async throws -> [Trip] {
        return [Trip.testOngoing, Trip.testFuture, .testPast]
    }
    
    func create(trip: Trip) async throws -> Trip {
        return Trip.testFuture
    }
    
    func editTrip(trip: Trip) async throws -> Trip {
        return Trip.testFuture
    }
    
    func getExploreTrips(searchTerm: String, tripStyle: TripStyle?, startDate: Date?, endDate: Date?) async throws -> [Trip] {
        return [Trip.testOngoing, Trip.testFuture, .testPast]
    }
    
    func subscribeToTripUpdates(for tripId: String, onNewUpdate: @escaping (String) -> Void) {}
    
    func subscribeToTripDeletion(for tripId: String, onDelete: @escaping (String) -> Void) {}
    
    func sendJoinRequest(tripId: String, message: String) async throws -> TripRequest {
        return .testRequestPending
    }
    
    func cancelJoinRequest(tripId: String) async throws {}
    
    func answerTravelRequest(request: TripRequest, approved: Bool) async throws -> TripRequest {
        return approved ? .testRequestApproved : .testRequestRejected
    }
    
    func getTrip(for tripId: String) async throws -> Trip {
        .testOngoing
    }
    
    func removeUser(tripId: String, userId: String) async throws {
    }
    
    func sendJoinInvite(tripId: String, userId: String) async throws -> TripRequest {
        .testInvitationPending
    }
    
    func answerTravelInvite(request: TripRequest, accepted: Bool) async throws -> TripRequest {
        return accepted ? .testInvitationAccepted : .testInvitationRejected
    }
    
    func leaveTrip(tripId: String) async throws {
    }
    
    func deleteTrip(tripId: String) async throws {
        
    }
    func reportTrip(tripId: String, reason: String) async throws {
    }
}
