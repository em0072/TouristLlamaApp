//
//  Local+MyTrips.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

extension String {
    
    enum Trips {
        static let title = String.localized("myTripsTitle")
        static let createTripButton = String.localized("myTripsCreateTripButton")
        
        static let generalInfoStage = String.localized("myTripsCreateTripGeneralInfoStage")
        static let descriptionStage = String.localized("myTripsCreateTripDescriptionStage")
        static let photoStage = String.localized("myTripsCreateTripPhotoStage")
        static let settingsStage = String.localized("myTripsCreateTripSettingsStage")

        
        static let createTripTitle = String.localized("myTripsCreateTripTitle")
        static let editTripTitle = String.localized("myTripsEditTripTitle")
        static let createTripName = String.localized("myTripsCreateTripName")
        static let createTripNamePlaceholder = String.localized("myTripsCreateTripNamePlaceholder")
        static let createTripStyle = String.localized("myTripsCreateTripStyle")
        static let createTripStylePlaceholder = String.localized("myTripsCreateTripStylePlaceholder")
        static let createTripLocation = String.localized("myTripsCreateTripLocation")
        static let createTripLocationPlaceholder = String.localized("myTripsCreateTripLocationPlaceHolder")
        static let createTripStartDate = String.localized("myTripsCreateTripStartDate")
        static let createTripEndDate = String.localized("myTripsCreateTripEndDate")
        static let createTripDatePlaceholde = String.localized("myTripsCreateTripDatePlaceholder")
        
        static let createTripDescription = String.localized("myTripsCreateTripDescription")
        static let createTripDescriptionPlaceholde = String.localized("myTripsCreateTripDescriptionPlaceholder")

        static let createTripPhoto = String.localized("myTripsCreateTripPhoto")
        
        static let createTripVisibilityTitle = String.localized("myTripsCreateTripVisibilityTitle")
        static let createTripVisibilityPrompt = String.localized("myTripsCreateTripVisibilityPrompt")
        static let createTripVisibilityDescription = String.localized("myTripsCreateTripVisibilityDescription")

        static let createTripLocationSearchTitle = String.localized("myTripsCreateTripLocationSearchTitle")
        static let createTripLocationSearchPrompt = String.localized("myTripsCreateTripLocationSearchPrompt")
        static let createTripLocationSearchResultsTitle = String.localized("myTripsCreateTripLocationSearchResultsTitle")
        static let createTripLocationSearchResultsPrompt = String.localized("myTripsCreateTripLocationSearchResultsPrompt")
        
        static let ongoingSectionTitle = String.localized("myTripsOngoingSectionTitle")
        static let futureSectionTitle = String.localized("myTripsFutureSectionTitle")
        static let pastSectionTitle = String.localized("myTripsPastSectionTitle")

        static let createErrorNoName = String.localized("myTripsCreateErrorNoName")
        static let createErrorNoStyle = String.localized("myTripsCreateErrorNoStyle")
        static let createErrorNoLocation = String.localized("myTripsCreateErrorNoLocation")
        static let createErrorNoStartDate = String.localized("myTripsCreateErrorNoStartDate")
        static let createErrorNoEndDate = String.localized("myTripsCreateErrorNoEndDate")
        static let createErrorNoDescription = String.localized("myTripsCreateErrorNoDescription")
        static let createErrorNoPhoto = String.localized("myTripsCreateErrorNoPhoto")
        
        static let searchPrompt = String.localized("exploreSearchPrompt")
        static let filtersTitle = String.localized("exploreFiltersTitle")
        static let filtersClear = String.localized("exploreFiltersClear")
        static let filtersTripStyle = String.localized("exploreFiltersTripStyle")
        static let filtersStartDate = String.localized("exploreFiltersStartDate")
        static let filtersEndDate = String.localized("exploreFiltersEndDate")
        static let filtersSelectDate = String.localized("exploreFiltersSelectDate")

        static func filtersSet(_ number: Int) -> String {
            if number == 0 {
                return String.localized("exploreNoFiltersSet")
            } else if number == 1 {
                return String.localized("exploreOneFilterSet")
            } else {
                return String(format: String.localized("exploreMultipleFiltersSet"), number)
            }
        }
    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Trips")
    }
}
