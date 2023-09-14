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
    @Dependency(\.tripsAPI) var tripsAPI
    @Dependency(\.tripsController) var tripsController

    @Published var trip: Trip
    @Published var isMembersManagmentOpen = false
    @Published var isLeaveTripConfirmationShown = false
    @Published var isDeleteTripConfirmationShown = false
    @Published var sheetType: SheetType?
    @Published var shouldDismiss = false
    
    enum SheetType: Identifiable {
        var id: Self { self }
        case report
        case applicationLetter
    }
    
    init(trip: Trip, isMembersManagmentOpen: Bool = false) {
        self.trip = trip
        self.isMembersManagmentOpen = isMembersManagmentOpen
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
    
    var isCurrentUserMemberOfTrip: Bool {
        guard let currentUser = userAPI.currentUser else { return false}
        return trip.participants.contains(where: { $0.id == currentUser.id })
    }
    
    var nonParticipantTripRequest: TripRequest? {
        guard !isCurrentUserMemberOfTrip else { return nil }
        return trip.requests.first
    }
    
    func updateTrip(updatedTrip: Trip) {
        self.trip = updatedTrip
    }

    func showLeaveTripConfirmation() {
        isLeaveTripConfirmationShown = true
    }

    func joinButtonAction() {
        sheetType = .applicationLetter
    }
    
    func joinRequestSend(message: String) {
        loadingState = .loading
        Task {
            do {
                let tripRequest = try await tripsAPI.sendJoinRequest(tripId: trip.id, message: message)
                trip.upsert(tripRequest: tripRequest)
                sheetType = nil
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func cancelJoinRequest(_ request: TripRequest) {
        Task {
            do {
                loadingState = .loading
                try await tripsAPI.cancelJoinRequest(request: request)
                trip.delete(tripRequest: request)
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func acceptInvite(_ request: TripRequest) {
        loadingState = .loading
        Task {
            do {
                let tripRequest = try await tripsAPI.answerTravelInvite(request: request, accepted: true)
                trip.upsert(tripRequest: tripRequest)
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }
    
    func rejectInvite(_ request: TripRequest) {
        loadingState = .loading
        Task {
            do {
                let tripRequest = try await tripsAPI.answerTravelInvite(request: request, accepted: false)
                trip.upsert(tripRequest: tripRequest)
            } catch {
                self.error = error
            }
            loadingState = .none
        }
    }

    
    func leaveTrip() {
        guard !isCurrentUserOwnerOfTrip else {
            self.error = CustomError(text: "Owner of the trip can't leave the trip")
            return
        }
        loadingState = .loading
        Task {
            do {
                try await tripsAPI.leaveTrip(tripId: trip.id)
                loadingState = .none
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    var tripDetailViewBottomOffsetAmount: CGFloat {
        guard !isCurrentUserMemberOfTrip else { return 10 }
        switch nonParticipantTripRequest?.status {
        case nil, .inviteRejected, .requestPending, .requestRejected, .requestCancelled:
            return 60
            
        case .invitePending:
            return 75
            
        default:
            return 10
        }
    }

    
    func showDeleteTripConfirmation() {
        isDeleteTripConfirmationShown = true
    }

    
    func deleteTrip() {
        guard isCurrentUserOwnerOfTrip else {
            self.error = CustomError(text: "Only an owner of the trip can delete the trip")
            return
        }
        loadingState = .loading
        Task {
            do {
                try await tripsAPI.deleteTrip(tripId: trip.id)
                loadingState = .none
                shouldDismiss = true
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    func reportTripButtonAction() {
        sheetType = .report
    }
    
    func reportTrip(reason: String) {
        loadingState = .loading
        Task {
            do {
                try await tripsAPI.reportTrip(tripId: trip.id, reason: reason)
                loadingState = .none
                sheetType = nil
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }

    func isCurrentUser(_ user: User) -> Bool {
        return userAPI.currentUser?.id == user.id
    }
    
    func openMembersManagment() {
        isMembersManagmentOpen = true
    }
    
    var hasPendingRequests: Bool {
        guard isCurrentUserOwnerOfTrip else { return false }
        return trip.hasRequests(with: .requestPending)
    }
    
    var pendingRequestsCount: Int {
        guard isCurrentUserOwnerOfTrip else { return 0 }
        return trip.requestsPendingCount
    }

}
