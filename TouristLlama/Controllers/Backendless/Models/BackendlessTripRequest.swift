//
//  BackendlessTripRequest.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import Foundation


import SwiftSDK

@objcMembers final class BackendlessTripReqest: NSObject {
    var objectId: String?
    var applicant: BackendlessUser?
    var applicationLetter: String?
    var rejectReason: String?
    var status: String?
    var tripId: String?

    override init() {
        super.init()
    }
    
    init(from tripRequest: TripRequest) {
        self.objectId = tripRequest.id
        self.applicant = tripRequest.applicant.blUser
        self.applicationLetter = tripRequest.applicationLetter
        self.rejectReason = tripRequest.rejectReason
        self.status = tripRequest.status.rawValue
        self.tripId = tripRequest.tripId
    }
        
    var appObject: TripRequest? {
        guard let objectId,
              let blApplicant = self.applicant,
              let applicant = User(from: blApplicant),
              let status = TripRequestStatus(rawValue: self.status ?? ""),
              let tripId else { return nil }
        
        let applicationLetter = self.applicationLetter ?? ""
        let rejectReason = self.rejectReason ?? ""

        return TripRequest(id: objectId,
                           applicant: applicant,
                           applicationLetter: applicationLetter,
                           rejectReason: rejectReason,
                           status: status,
                           tripId: tripId)
    }
    
}
