//
//  TripDetailViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import Foundation
import Dependencies

class TripDetailViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
        super.init()
    }
    
    var tripImageURL: URL {
        trip.photo.large
    }

    var tripDatesText: String {
        guard let start = DateHandler().dateToString(trip.startDate),
              let end = DateHandler().dateToString(trip.endDate) else { return "" }
        return "\(start) - \(end)"
    }
    
    var numberOfNightsText: String {
        guard let num = Calendar(identifier: .gregorian).numberOfDaysBetween(trip.startDate, and: trip.endDate) else {
            return ""
        }
        return String.Trip.numberOfNights(num)
    }
    
    var isCurrentUserOwnerOfTrip: Bool {
        guard let currentUser = userAPI.currentUser else { return false}
        return trip.ownerId == currentUser.id
    }


    func isCurrentUser(_ user: User) -> Bool {
        return userAPI.currentUser?.id == user.id
    }

}