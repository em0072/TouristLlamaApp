//
//  ExploreViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import Foundation
import Dependencies

class ExploreViewModel: ViewModel {
    
    @Dependency(\.tripsController) var tripsController
    @Dependency(\.userDefaultsController) var userDefaultsController
    @Dependency(\.userAPI) var userAPI

    @Published var searchPrompt: String = ""
    @Published var isSearching: Bool = false {
        didSet {
            if isSearching && state == .content {
                loadingState = .loading
            } else {
                loadingState = .none
            }
        }
    }
    @Published var areFiltersOpen: Bool = false
    @Published var filters: Filters = .init()
    @Published var trips = [Trip]()
//    @Published var tripToOpen: Trip?
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToSearchTerm()
        subscribeToAllTrips()
    }

    var filtersTitle: String? {
        if filters.settedCount == 0 {
            return nil
        } else {
            return String.Trips.filtersSet(filters.settedCount)
        }
    }
    
    func openFilters() {
        areFiltersOpen = true
    }
    
    func clearFilters() {
        filters.clear()
        searchTrips()
    }
    
    func searchTrips() {
                isSearching = true
                tripsController.searchTrips(searchTerm: searchPrompt,
                                            tripStyle: filters.tripStyle,
                                            startDate: filters.startDate,
                                            endDate: filters.endDate)
    }
    
    func open(_ trip: Trip) {
        tripsController.open(tripOpenState: .details(trip))
    }
    
    func set(_ filters: Filters) {
        self.filters = filters
        self.searchTrips()
    }
    
    func shouldShowNotificationBadge(_ trip: Trip) -> Bool {
        guard let currentUser = userAPI.currentUser else { return false }
        for request in trip.requests {
            // Show badge if there is an invite for a user
            if request.applicant.id == currentUser.id && request.status == .invitePending {
                return true
            }
            // Show badge if there is a join request for a trip owner
            if trip.ownerId == currentUser.id && request.status == .requestPending {
                return true
            }
        }
        if trip.participants.contains(where: { currentUser.id == $0.id }),
           let lastMessage = trip.lastMessage,
           lastMessage.id != userDefaultsController.getLastMessageIf(for: trip.id) {
            return true
        }
        return false
    }
    
    private func subscribeToSearchTerm() {
        $searchPrompt
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] searchTerm in
                guard let self else { return }
                self.searchTrips()
            }
            .store(in: &publishers)
    }
    
    private func subscribeToAllTrips() {
        tripsController.$exploreTrips
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] allTrips in
                guard let allTrips else { return }
                self?.trips = allTrips
                self?.state = .content
                self?.isSearching = false
            })
            .store(in: &publishers)
    }
}
