//
//  TripRequest+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/08/2023.
//

import Foundation

extension TripRequest {
    
    static var testRequestPending: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "In the vast expanse of the universe, where countless stars shine brilliantly, weaving tales of cosmic wonder, humanity seeks to comprehend the infinite, bridging gaps of knowledge with persistent curiosity, while dreaming of distant galaxies, uncharted territories, and the mysteries they might one day unlock, nurturing hope for endless discovery.", rejectReason: "", status: .requestPending, tripId: "dfcfvgr34")
    }
    
    static var testRequestRejected: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "hey", rejectReason: "", status: .requestRejected, tripId: "dfcfvgr34")
    }
    
    static var testRequestApproved: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "hey", rejectReason: "", status: .requestApproved, tripId: "dfcfvgr34")
    }

    static var testInvitationPending: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "hey", rejectReason: "", status: .invitePending, tripId: "dfcfvgr34")
    }

    static var testInvitationRejected: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "hey", rejectReason: "", status: .inviteRejected, tripId: "dfcfvgr34")
    }

    static var testInvitationAccepted: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "hey", rejectReason: "", status: .inviteAccepted, tripId: "dfcfvgr34")
    }
    
    static var testRequestCancelled: TripRequest {
        TripRequest(id: "2df2f", applicant: .testNotInvited, applicationLetter: "hey", rejectReason: "", status: .requestCancelled, tripId: "dfcfvgr34")
    }


}
