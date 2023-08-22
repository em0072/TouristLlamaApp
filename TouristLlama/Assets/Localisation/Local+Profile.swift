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

        static let fullName = String.localized("editProfileFullName")
        static let username = String.localized("editProfileUsername")
        static let pronoun = String.localized("editProfilePronoun")
        static let aboutMe = String.localized("editProfileAboutMe")
        static let editProfilePictureTitle = String.localized("editProfileEditProfilePictureTitle")
        static let editProfilePictureSubtitle = String.localized("editProfileEditProfilePictureSubtitle")
        static let changeProfilePhoto = String.localized("editProfileChangeProfilePhoto")
        static let chooseNickname = String.localized("editProfileChooseNickname")
        static let usernameLimitText = String.localized("editProfileUsernameLimitText")
        static let usernameAvailable = String.localized("editProfileUsernameAvailable")
        static let usernameTaken = String.localized("editProfileUsernameTaken")
        static let email = String.localized("editProfileEmail")
        static let phoneNumber = String.localized("editProfilePhoneNumber")
        static let dateOfBirth = String.localized("editProfileDateOfBirth")
        static let descriptionPlaceholder = String.localized("editProfileDescriptionPlaceholder")
        static let personalInformationSettings = String.localized("editProfilePersonalInformationSettings")

        
    }
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Profile")
    }
}
