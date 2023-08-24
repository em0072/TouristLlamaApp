//
//  TripCreationStage.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 11/08/2023.
//

import SwiftUI

enum TripCreationStage: Identifiable, CaseIterable {
    
    var id: Self { return self }
    
    case generalInfo
    case description
    case photo
    case settings
    
    var value: String {
        return "self.rawValue"
    }

    var name: String {
        switch self {
        case .generalInfo:
            return String.Trips.generalInfoStage
            
        case .description:
            return String.Trips.descriptionStage
            
        case .photo:
            return String.Trips.photoStage
            
        case .settings:
            return String.Trips.settingsStage
        }
    }
    
    var icon: Image {
        switch self {
        case .generalInfo:
            return Image(systemName: "info")

        case .description:
            return Image(systemName: "pencil")
            
        case .photo:
            return Image(systemName: "photo")
            
        case .settings:
            return Image(systemName: "gear")
        }
    }

}
