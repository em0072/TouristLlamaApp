//
//  Local+Profile.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import Foundation

extension String {
    
    enum Profile {
        static let trips = String.localized("profileCounterTrips")
        static let awards = String.localized("profileCounterAwards")
        static let friends = String.localized("profileCounterFriends")
        
        static let editProfile = String.localized("profileEditProfile")
        
        static let manageTrips = String.localized("profileManageFriends")
        static let manageTripsSubtitle = String.localized("profileManageFriendsSubtitle")

        static let exploreAwards = String.localized("profileExploreAwards")

        static let settingsTitle = String.localized("profileSettingsTitle")
        static let logoutPromptTitle = String.localized("profileSettingsLogoutPromptTitle")
        static let logoutPromptMessage = String.localized("profileSettingsLogoutPromptMessage")
        static let logout = String.localized("profileSettingsLogout")

    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Profile")
    }
}
