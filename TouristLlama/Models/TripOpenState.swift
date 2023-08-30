//
//  TripOpenState.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import Foundation

enum TripOpenState: Identifiable {
        
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
}
