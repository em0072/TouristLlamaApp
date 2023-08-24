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
    @Published var isSearching: Bool = false
    @Published var areFiltersOpen: Bool = false
    @Published var trips = [Trip]()

    func openFilters() {
        areFiltersOpen = true
    }
    
    func requestTrips() {
        Task {
            do {
                trips = try await tripAPI.getExploreTrips()
                state = .content
            } catch {
                self.error = error
            }
        }
    }
}
