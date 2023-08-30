//
//  TripRequestStatus.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import Foundation

enum TripRequestStatus: String, Pickable {
    case requestApproved
    case requestRejected
    case requestPending
    case requestCancelled
    case inviteAccepted
    case inviteRejected
    case invitePending
}
