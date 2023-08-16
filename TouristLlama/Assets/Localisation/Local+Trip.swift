//
//  Local+Trip.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension String {
    
    enum Trip {
        enum Style {
            static let info = String.localized("tripStyleInfo")
            
            // Travel Style Names
            static let leisure = String.localized("tripStyleLeisure")
            static let active = String.localized("tripStyleActive")
            static let cultural = String.localized("tripStyleCultural")
            static let adventure = String.localized("tripStyleAdventure")
            static let natureAndWildlife = String.localized("tripStyleNatureAndWildlife")
            static let beachAndMarine = String.localized("tripStyleBeachAndMarine")
            static let culinary = String.localized("tripStyleCulinary")
            static let nightlifeAndParty = String.localized("tripStyleNightlifeAndParty")
            static let budgetBackpacking = String.localized("tripStyleBudgetBackpacking")
            static let luxury = String.localized("tripStyleLuxury")
            static let family = String.localized("tripStyleFamily")
            static let solo = String.localized("tripStyleSolo")
            static let business = String.localized("tripStyleBusiness")
            static let ecoTourism = String.localized("tripStyleEcoTourism")
            static let volunteering = String.localized("tripStyleVolunteering")
            static let festivalAndEvents = String.localized("tripStyleFestivalAndEvents")
            
            // Travel Style Descriptions
            static let leisureDescription = String.localized("tripStyleLeisureDescription")
            static let activeDescription = String.localized("tripStyleActiveDescription")
            static let culturalDescription = String.localized("tripStyleCulturalDescription")
            static let adventureDescription = String.localized("tripStyleAdventureDescription")
            static let natureAndWildlifeDescription = String.localized("tripStyleNatureAndWildlifeDescription")
            static let beachAndMarineDescription = String.localized("tripStyleBeachAndMarineDescription")
            static let culinaryDescription = String.localized("tripStyleCulinaryDescription")
            static let nightlifeAndPartyDescription = String.localized("tripStyleNightlifeAndPartyDescription")
            static let budgetBackpackingDescription = String.localized("tripStyleBudgetBackpackingDescription")
            static let luxuryDescription = String.localized("tripStyleLuxuryDescription")
            static let familyDescription = String.localized("tripStyleFamilyDescription")
            static let soloDescription = String.localized("tripStyleSoloDescription")
            static let businessDescription = String.localized("tripStyleBusinessDescription")
            static let ecoTourismDescription = String.localized("tripStyleEcoTourismDescription")
            static let volunteeringDescription = String.localized("tripStyleVolunteeringDescription")
            static let festivalAndEventsDescription = String.localized("tripStyleFestivalAndEventsDescription")
        }
        static let detailsTitle = String.localized("tripDetailsTitle")
        static let discussionTitle = String.localized("tripDiscussionTitle")

        static let datesTitle = String.localized("tripDatesTitle")

        static let aboutTitle = String.localized("tripAboutTitle")

        static let paticipantsTitle = String.localized("tripPaticipantsTitle")
        static let organizer = String.localized("organizer")

        static let mapTitle = String.localized("tripMapTitle")

        static func numberOfNights(_ number: Int) -> String {
            if number == 0 {
                return String.localized("tripOneDayTrip")
            } else if number == 1 {
                return String.localized("tripOneNight")
            } else {
                return String(format: String.localized("tripNumberNights"), number)
            }
        }

    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Trip")
    }
}
