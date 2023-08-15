//
//  TripAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 14/08/2023.
//

import Foundation
import Combine

class TripsAPIMock: TripsAPIProvider {
    
    func getMyTrips() async throws -> [Trip] {
        return [Trip.testOngoing, Trip.testFuture]
    }
    
    func create(trip: Trip) async throws -> Trip {
        return Trip.testFuture
    }
}
