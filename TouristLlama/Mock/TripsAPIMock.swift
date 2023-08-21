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
}
