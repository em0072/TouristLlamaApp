//
//  TripStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

enum TripStyle: String, Identifiable, CaseIterable {
    
    var id: String { rawValue }
//    case none
    case leisure
    case active
    case cultural
    case adventure
    case natureAndWildlife
    case beachAndMarine
    case culinary
    case nightlifeAndParty
    case budgetBackpacking
    case luxury
    case family
    case solo
    case business
    case ecoTourism
    case volunteering
    case festivalAndEvents
    
    var localizedValue: String {
        switch self {
//        case .none: return ""
        case .leisure: return String.Trip.Style.leisure
        case .active:  return String.Trip.Style.active
        case .cultural:  return String.Trip.Style.cultural
        case .adventure: return String.Trip.Style.adventure
        case .natureAndWildlife:  return String.Trip.Style.natureAndWildlife
        case .beachAndMarine:  return String.Trip.Style.beachAndMarine
        case .culinary:  return String.Trip.Style.culinary
        case .nightlifeAndParty:  return String.Trip.Style.nightlifeAndParty
        case .budgetBackpacking: return String.Trip.Style.budgetBackpacking
        case .luxury:  return String.Trip.Style.luxury
        case .family:  return String.Trip.Style.family
        case .solo:  return String.Trip.Style.solo
        case .business:  return String.Trip.Style.business
        case .ecoTourism:  return String.Trip.Style.ecoTourism
        case .volunteering:  return String.Trip.Style.volunteering
        case .festivalAndEvents: return String.Trip.Style.festivalAndEvents
        }
    }
    
    var localizedDescription: String {
        switch self {
//        case .none: return ""
        case .leisure: return String.Trip.Style.leisureDescription
        case .active: return String.Trip.Style.activeDescription
        case .cultural: return String.Trip.Style.culturalDescription
        case .adventure: return String.Trip.Style.adventureDescription
        case .natureAndWildlife: return String.Trip.Style.natureAndWildlifeDescription
        case .beachAndMarine: return String.Trip.Style.beachAndMarineDescription
        case .culinary: return String.Trip.Style.culinaryDescription
        case .nightlifeAndParty: return String.Trip.Style.nightlifeAndPartyDescription
        case .budgetBackpacking: return String.Trip.Style.budgetBackpackingDescription
        case .luxury: return String.Trip.Style.luxuryDescription
        case .family: return String.Trip.Style.familyDescription
        case .solo: return String.Trip.Style.soloDescription
        case .business: return String.Trip.Style.businessDescription
        case .ecoTourism: return String.Trip.Style.ecoTourismDescription
        case .volunteering: return String.Trip.Style.volunteeringDescription
        case .festivalAndEvents: return String.Trip.Style.festivalAndEventsDescription
        }
    }
    
    var styleColor: Color {
            switch self {
//            case .none: return .clear
            case .leisure: return Color(red: 240/255, green: 230/255, blue: 140/255)
            case .active: return Color(red: 173/255, green: 216/255, blue: 230/255)
            case .cultural: return Color(red: 221/255, green: 160/255, blue: 221/255)
            case .adventure: return Color(red: 152/255, green: 251/255, blue: 152/255)
            case .natureAndWildlife: return Color(red: 255/255, green: 192/255, blue: 203/255)
            case .beachAndMarine: return Color(red: 135/255, green: 206/255, blue: 250/255)
            case .culinary: return Color(red: 255/255, green: 182/255, blue: 193/255)
            case .nightlifeAndParty: return Color(red: 240/255, green: 128/255, blue: 128/255)
            case .budgetBackpacking: return Color(red: 224/255, green: 255/255, blue: 255/255)
            case .luxury: return Color(red: 250/255, green: 235/255, blue: 215/255)
            case .family: return Color(red: 255/255, green: 228/255, blue: 225/255)
            case .solo: return Color(red: 255/255, green: 218/255, blue: 185/255)
            case .business: return Color(red: 230/255, green: 230/255, blue: 250/255)
            case .ecoTourism: return Color(red: 250/255, green: 250/255, blue: 210/255)
            case .volunteering: return Color(red: 255/255, green: 240/255, blue: 245/255)
            case .festivalAndEvents: return Color(red: 240/255, green: 230/255, blue: 140/255)
            }
        }

    var styleSymbol: String {
            switch self {
//            case .none: return ""
            case .leisure: return "sun.dust.fill"
            case .active: return "figure.walk"
            case .cultural: return "book.fill"
            case .adventure: return "map.fill"
            case .natureAndWildlife: return "leaf.arrow.circlepath"
            case .beachAndMarine: return "sun.max.fill"
            case .culinary: return "fork.knife"
            case .nightlifeAndParty: return "music.mic"
            case .budgetBackpacking: return "backpack.fill"
            case .luxury: return "crown.fill"
            case .family: return "house.fill"
            case .solo: return "person.fill"
            case .business: return "briefcase.fill"
            case .ecoTourism: return "leaf.fill"
            case .volunteering: return "hands.clap.fill"
            case .festivalAndEvents: return "star.circle.fill"
            }
        }

}
