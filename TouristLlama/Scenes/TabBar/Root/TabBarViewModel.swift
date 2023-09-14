//
//  TabBarViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import Foundation
import Dependencies

enum TabOption {
    case explore
    case myTrips
    case notifications
    case profile
}

class TabBarViewModel: ViewModel {
    
    @Dependency(\.notificationsAPI) var notificationsAPI
    @Dependency(\.tripsController) var tripsController

    @Published var selectedTab: TabOption = .explore
    @Published var notificationsBadgeNumber: Int = 0
    @Published var selectedTripOpenState: TripOpenState? {
        didSet {
            guard selectedTripOpenState != tripsController.selectedTripState else { return }
            tripsController.selectedTripState = selectedTripOpenState
        }
    }

    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToNotificationsBadgeUpdate()
        subscribeToTripOpenState()
    }

    var exploreTabIcon: String {
        selectedTab == .explore ? "safari.fill" : "safari"
    }
    
    var myTripsTabIcon: String {
        selectedTab == .myTrips ? "calendar.circle.fill" : "calendar.circle"
    }

    var notificationsTabIcon: String {
        selectedTab == .notifications ? "bell.circle.fill" : "bell.circle"
    }

    var profileTabIcon: String {
        selectedTab == .profile ? "person.circle.fill" : "person.circle"
    }

    private func subscribeToNotificationsBadgeUpdate() {
        notificationsAPI.$unreadNotifications
            .receive(on: RunLoop.main)
            .sink { [weak self] badgeNumber in
                guard let self else { return }
                self.notificationsBadgeNumber = badgeNumber
            }
            .store(in: &publishers)
    }
    
    private func subscribeToTripOpenState() {
        tripsController.$selectedTripState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] tripOpenState in
                guard let self, self.selectedTripOpenState != tripOpenState else { return }
                self.selectedTripOpenState = tripOpenState
            })
            .store(in: &publishers)
    }
}
