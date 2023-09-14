//
//  TripOpenState.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import Foundation

enum TripOpenState: Identifiable, Equatable {
        
    var id: String {
        switch self {
        case .details(let trip):
            return trip.id

        case .members(let trip):
            return trip.id

        case .chat(let trip):
            return trip.id

        }
    }
    
    case details(Trip)
    case members(Trip)
    case chat(Trip)
    
    var trip: Trip {
        switch self {
        case .details(let trip):
            return trip

        case .members(let trip):
            return trip

        case .chat(let trip):
            return trip
        }
    }
    
    mutating func updateTrip(newTrip: Trip) {
        switch self {
        case .details:
            self = .details(newTrip)

        case .members:
            self = .members(newTrip)

        case .chat:
            self = .chat(newTrip)
        }
    }
}

