//
//  TripStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

enum TripStyle: String, Pickable {
    case none
    case leisure
    case active
    
    var localizedValue: String {
        switch self {
        case .none:
            return ""
        case .leisure:
            return String.Trip.Style.leisure
            
        case .active:
            return String.Trip.Style.active
        }
    }
}
