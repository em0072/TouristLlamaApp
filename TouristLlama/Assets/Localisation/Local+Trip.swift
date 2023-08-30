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
        static let invitedUser = String.localized("invitedUser")
        static let inviteRejected = String.localized("inviteRejected")
        static let requestRejected = String.localized("requestRejected")

        static let manageMembersTitle = String.localized("tripManageMembersTitle")
        static let manageMembersSubitle = String.localized("tripManageMembersSubitle")
        
        static let manageRequestsSectionTitle = String.localized("tripManageRequestsSectionTitle")
        static func manageRequests(_ number: Int) -> String {
            if number == 0 {
                return String.localized("")
            } else if number == 1 {
                return String.localized("tripManageRequestsOneMore")
            } else {
                return String(format: String.localized("tripManageRequestsMore"), number)
            }
        }
        static let manageTeammatesSectionTitle = String.localized("tripManageTeammatesSectionTitle")
        static let manageRejectedSectionTitle = String.localized("tripManageRejectedSectionTitle")
        static let manageRemoveUserDialogTitle = String.localized("tripManageRemoveUserDialogTitle")
        static let manageRemoveUserDialogSubtitle = String.localized("tripManageRemoveUserDialogSubtitle")

        
        
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
        
        //MARK: - Members Manage
        static let requestToJoin = String.localized("tripRequestToJoin")
        static let requestApplicationLetterTitle = String.localized("tripRequestApplicationLetterTitle")
        static let requestApplicationLetterSubtitle = String.localized("tripRequestApplicationLetterSubtitle")
        static let requestApplicationLetterPrompt = String.localized("tripRequestApplicationLetterPrompt")
        static let requestToJoinSend = String.localized("tripRequestToJoinSend")
        static let requestToJoinPending = String.localized("tripRequestToJoinPending")
        static let requestToJoinRejected = String.localized("tripRequestToJoinRejected")
        static let requestToJoinAgain = String.localized("tripRequestToJoinAgain")
        static let inviteToJoinPending = String.localized("tripInviteToJoinPending")
        static let inviteToJoinRejected = String.localized("tripInviteToJoinRejected")

        
        //MARK: - User Search
        static let userSearchInitialInstruction = String.localized("userSearchInitialInstruction")

    }
    

    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Trip")
    }
}
