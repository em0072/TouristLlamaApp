//
//  TripRequest.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import Foundation

struct TripRequest: Identifiable, Equatable {
    
    var id: String
    var applicant: User
    var applicationLetter: String
    var rejectReason: String
    var status: TripRequestStatus
    var tripId: String
    
}
