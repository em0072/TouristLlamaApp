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

    init(provider: TripsAPIProvider) {
        self.provider = provider
        updateMyTrips()
    }
    
    private func updateMyTrips() {
        Task {
            do {
                myTrips = try await provider.getMyTrips()
                myTripsIsLoaded = true
            } catch {
                print(error)
            }
        }
    }

    func create(trip: Trip) async throws {
        let newTrip = try await provider.create(trip: trip)
        addTripToMyTrips(newTrip)
    }
    
    private func addTripToMyTrips(_ trip: Trip) {
        myTrips.append(trip)
        myTrips.sort { $0.startDate > $1.startDate }
    }

}
