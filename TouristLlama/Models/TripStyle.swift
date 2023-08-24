//
//  TripStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

enum TripStyle: String, Identifiable, CaseIterable, Equatable {
    
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
        case .leisure:
            return Color(red: 255/255, green: 231/255, blue: 112/255)
        case .active:
            return Color(red: 255/255, green: 200/255, blue: 200/255)
        case .cultural:
            return Color(red: 217/255, green: 203/255, blue: 255/255)
        case .adventure:
            return Color(red: 240/255, green: 209/255, blue: 132/255)
        case .natureAndWildlife:
            return Color(red: 166/255, green: 231/255, blue: 162/255)
        case .beachAndMarine:
            return Color(red: 160/255, green: 229/255, blue: 255/255)
        case .culinary:
            return Color(red: 255/255, green: 172/255, blue: 151/255)
        case .nightlifeAndParty:
            return Color(red: 255/255, green: 184/255, blue: 228/255)
        case .budgetBackpacking:
            return Color(red: 167/255, green: 195/255, blue: 255/255)
        case .luxury:
            return Color(red: 255/255, green: 213/255, blue: 113/255)
        case .family:
            return Color(red: 255/255, green: 197/255, blue: 117/255)
        case .solo:
            return Color(red: 109/255, green: 207/255, blue: 255/255)
        case .business:
            return Color(red: 174/255, green: 174/255, blue: 250/255)
        case .ecoTourism:
            return Color(red: 139/255, green: 219/255, blue: 117/255)
        case .volunteering:
            return Color(red: 255/255, green: 183/255, blue: 165/255)
        case .festivalAndEvents:
            return Color(red: 248/255, green: 183/255, blue: 255/255)
        }
    }

    var styleTextColor: Color {
        switch self {
        case .leisure:
            return Color(red: 154/255, green: 90/255, blue: 0/255)
        case .active:
            return Color(red: 217/255, green: 12/255, blue: 12/255)
        case .cultural:
            return Color(red: 87/255, green: 49/255, blue: 200/255)
        case .adventure:
            return Color(red: 153/255, green: 109/255, blue: 0/255)
        case .natureAndWildlife:
            return Color(red: 7/255, green: 128/255, blue: 0/255)
        case .beachAndMarine:
            return Color(red: 0/255, green: 118/255, blue: 255/255)
        case .culinary:
            return Color(red: 128/255, green: 26/255, blue: 0/255)
        case .nightlifeAndParty:
            return Color(red: 159/255, green: 0/255, blue: 99/255)
        case .budgetBackpacking:
            return Color(red: 0/255, green: 74/255, blue: 231/255)
        case .luxury:
            return Color(red: 129/255, green: 91/255, blue: 0/25)
        case .family:
            return Color(red: 128/255, green: 74/255, blue: 0/255)
        case .solo:
            return Color(red: 0/255, green: 79/255, blue: 118/255)
        case .business:
            return Color(red: 0/255, green: 0/255, blue: 165/255)
        case .ecoTourism:
            return Color(red: 24/255, green: 110/255, blue: 0/255)
        case .volunteering:
            return Color(red: 152/255, green: 30/255, blue: 0/255)
        case .festivalAndEvents:
            return Color(red: 141/255, green: 0/255, blue: 156/255)
        }
    }


    var styleSymbol: String {
            switch self {
//            case .none: return ""
            case .leisure: return "sun.dust.fill"
            case .active: return "figure.walk"
            case .cultural: return "building.columns.fill"
            case .adventure: return "figure.surfing"
            case .natureAndWildlife: return "tree.fill"
            case .beachAndMarine: return "beach.umbrella.fill"
            case .culinary: return "fork.knife"
            case .nightlifeAndParty: return "party.popper.fill"
            case .budgetBackpacking: return "backpack.fill"
            case .luxury: return "crown.fill"
            case .family: return "figure.2.and.child.holdinghands"
            case .solo: return "person.fill"
            case .business: return "briefcase.fill"
            case .ecoTourism: return "leaf.fill"
            case .volunteering: return "hands.clap.fill"
            case .festivalAndEvents: return "star.circle.fill"
            }
        }

}

