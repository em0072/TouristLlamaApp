//
//  ExploreViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import Foundation
import Dependencies

class ExploreViewModel: ViewModel {
    
    @Dependency(\.tripsAPI) var tripAPI
    
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
    @Published var tripToOpen: Trip?
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToSearchTerm()
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
        requestTrips()
    }
    
    func requestTrips() {
        Task {
            do {
                isSearching = true
                trips = try await tripAPI.getExploreTrips(searchTerm: searchPrompt,
                                                          tripStyel: filters.tripStyle,
                                                          startDate: filters.startDate,
                                                          endDate: filters.endDate)
                state = .content
                isSearching = false
            } catch {
                self.error = error
                isSearching = false
            }
        }
    }
    
    func open(_ trip: Trip) {
        tripToOpen = trip
    }
    
    func set(_ filters: Filters) {
        self.filters = filters
        self.requestTrips()
    }
    
    private func subscribeToSearchTerm() {
        $searchPrompt
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] searchTerm in
                self?.requestTrips()
            }
            .store(in: &publishers)
    }
}
