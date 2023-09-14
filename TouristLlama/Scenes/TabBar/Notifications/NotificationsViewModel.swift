//
//  NotificationsViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import SwiftUI
import Dependencies
import Combine

class NotificationsViewModel: ViewModel {
    
    @Dependency(\.notificationsAPI) var notificationsAPI
    @Dependency(\.tripsController) var tripsController

    @Published var myNotifications: [UserNotification] = []
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToMyNotifications()
    }
    
    private func subscribeToMyNotifications() {
        notificationsAPI.$notifications
            .receive(on: RunLoop.main)
            .sink { [weak self] notifications in
                guard let self else { return }
                withAnimation {
                    self.myNotifications = notifications
                }
                self.state = .content
            }
            .store(in: &publishers)
    }
    
    func deleteNotification(id: String) {
        notificationsAPI.deleteNotification(id: id)
    }
    
    func markNotificationAsRead(id: String) {
        notificationsAPI.markNotificationAsRead(id: id)
    }
    
    func markAllNotificationAsRead() {
        notificationsAPI.markAllNotificationsAsRead()
    }
    
    @MainActor
    func openTrip(tripId: String) {
        loadingState = .loading
        Task {
            do {
                let trip = try await tripsController.getTrip(tripId: tripId)
                loadingState = .none
                tripsController.selectedTripState = .details(trip)
            } catch {
                self.error = error
            }
        }
    }
}
