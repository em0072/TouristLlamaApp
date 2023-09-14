//
//  TripManageMembersViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import SwiftUI
import Dependencies

class TripManageMembersViewModel: ViewModel {

    @Dependency(\.userAPI) var userAPI
    @Dependency(\.tripsAPI) var tripAPI

    @Published var trip: Trip {
        didSet {
            sortData()
        }
    }
    @Published var participants: [User] = []
    @Published var invitationsPending: [TripRequest] = []
    @Published var invitationsRejected: [TripRequest] = []
    @Published var requestsPending: [TripRequest] = []
    @Published var requestsRejected: [TripRequest] = []
    @Published var selectedUser: User?
    @Published private var userToRemove: User?
    @Published var isRemoveUserConfirmationShown = false
    @Published var isInviteViewShown = false


    init(trip: Trip) {
        self.trip = trip
        super.init()
        sortData()
    }
        
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
//        subscribeToTripUpdates()
        subscribeToInvitedUsers()
    }

    var isCurrentUserTripOrganiser: Bool {
        guard let currentUser = userAPI.currentUser else { return false }
        return trip.ownerId == currentUser.id
    }
    
    var shortListOfPendingRequests: [TripRequest] {
        return Array(requestsPending.prefix(2))
    }
    
    var remainPendingRequestCount: Int {
        requestsPending.count - shortListOfPendingRequests.count
    }
    
    func deleteButtonAction(_ participant: User) {
        userToRemove = participant
        isRemoveUserConfirmationShown = true
    }
    
    func deleteAction() {
        guard let userToRemove else { return }
        
        if trip.participants.contains(userToRemove) {
            removeUser(user: userToRemove)
        } else if invitationsPending.contains(where: { $0.applicant.id == userToRemove.id }) {
            cancelUserInvite(user: userToRemove)
        }
    }
    
    private func removeUser(user: User) {
        loadingState = .loading
        Task {
            do {
                try await tripAPI.removeUser(tripId: trip.id, userId: user.id)
                deleteMemberFromTrip()
                loadingState = .none
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    private func cancelUserInvite(user: User) {
        loadingState = .loading
        Task {
            do {
                try await tripAPI.cancelInvite(tripId: trip.id, userId: user.id)
                deleteMemberFromInvite()
                loadingState = .none
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    func inviteNewUserButtonAction() {
        isInviteViewShown = true
    }

    func canInvite(_ user: User) -> Bool {
        user.id != trip.ownerId && !trip.participants.contains(user)
    }
    
    func invite(_ user: User) {
        loadingState = .loading
        Task {
            do {
                let request = try await tripAPI.sendJoinInvite(tripId: trip.id, userId: user.id)
                updateTripWith(request)
                isInviteViewShown = false
                loadingState = .none
            } catch {
                loadingState = .error(error)
            }
        }
    }
    
    func approve(_ request: TripRequest) {
        Task {
            loadingState = .loading
            do {
                let updatedRequest = try await tripAPI.answerTravelRequest(request: request, approved: true)
                updateTripWith(updatedRequest)
                loadingState = .none
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    func deny(_ request: TripRequest) {
        Task {
            loadingState = .loading
            do {
                let updatedRequest = try await tripAPI.answerTravelRequest(request: request, approved: false)
                updateTripWith(updatedRequest)
                loadingState = .none
            } catch {
                self.error = error
                loadingState = .none
            }
        }
    }
    
    func updateTripWith(_ newRequest: TripRequest) {
        if newRequest.status == .requestApproved {
            trip.delete(tripRequest: newRequest)
            trip.add(participant: newRequest.applicant)
        } else if newRequest.status == .requestRejected {
            trip.upsert(tripRequest: newRequest)
        }
    }

    
    private func deleteMemberFromTrip() {
        guard let userToRemove, let userIndex = trip.participants.firstIndex(where: { $0.id == userToRemove.id }) else { return }
        _ = withAnimation {
            trip.participants.remove(at: userIndex)
        }
    }
    
    private func deleteMemberFromInvite() {
        guard let userToRemove, let inviteIndex = invitationsPending.firstIndex(where: { $0.applicant.id == userToRemove.id }) else { return }
        _ = withAnimation {
            invitationsPending.remove(at: inviteIndex)
        }
    }
    
    
    private func sortData() {
        self.participants = trip.participants
        
        invitationsPending.removeAll()
        invitationsRejected.removeAll()
        requestsPending.removeAll()
        requestsRejected.removeAll()

        for request in trip.requests {
            switch request.status {
            case .invitePending:
                invitationsPending.append(request)
                
            case .inviteRejected:
                invitationsRejected.append(request)
                
            case .requestPending:
                requestsPending.append(request)
                
            case .requestRejected:
                requestsRejected.append(request)
                
            default:
                continue
            }
        }
    }
    
//    private func subscribeToTripUpdates() {
//        tripAPI.subscribreToTripUpdates(with: trip.id)
//            .sink(receiveValue: { [weak self] updatedTrip in
//                self?.trip = updatedTrip
//            })
//            .store(in: &publishers)
////            .assign(to: &$trip)
//    }
    
    private func subscribeToInvitedUsers() {
//        TripService.shared.subscribeToTripRequests(tripId: trip.id.description, usersStatus: .invited)
//            .sink { [weak self] completion in
//                if case .failure(let error) = completion {
//                    self?.error = error
//                }
//            } receiveValue: { [weak self] tripRequests in
//                self?.invitedUsers = tripRequests.map({ $0.user })
//            }.store(in: &publishers)
    }

}
