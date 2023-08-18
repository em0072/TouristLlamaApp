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
//    func getTripDiscussion(for tripId: String) async throws -> TripDiscussion 
}
