//
//  NotificationsAPI.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

class NotificationsAPI {
    
    private let provider: NotificationsAPIProvider
    
    @Published var notifications: [UserNotification] = []
    @Published var unreadNotifications: Int = 0

    init(provider: NotificationsAPIProvider) {
        self.provider = provider
        getMyNotifications()
    }
    
    private func getMyNotifications() {
        Task {
            do {
                notifications = try await provider.getMyNotifications()
                updateUnreadNotificationsCount()
                subscribreToNotificationUpdates()
            } catch {
                print(error)
            }
        }
    }
    
    private func subscribreToNotificationUpdates() {
        provider.subscribeToNotificationsUpdates { [weak self] notification in
            guard let self else { return }
            self.notifications.insert(notification, at: 0)
            if !notification.read {
                self.unreadNotifications += 1
            }
        }
    }
    
    func deleteNotification(id: String) {
        notifications.removeAll(where: { $0.id == id })
        updateUnreadNotificationsCount()
        Task {
            do {
                try await provider.deleteNotification(id: id)
            } catch {
                print(error)
            }
        }
    }
    
    func markNotificationAsRead(id: String) {
        guard let notificationIndex = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[notificationIndex].read = true
        updateUnreadNotificationsCount()
        Task {
            do {
                try await provider.markNotificationAsRead(id: id)
            } catch {
                print(error)
            }
        }
    }
    
    func markAllNotificationsAsRead() {
        for i in 0..<notifications.count {
            notifications[i].markAsRead()
        }
        updateUnreadNotificationsCount()
        Task {
            do {
                try await provider.markAllNotificationsAsRead()
            } catch {
                print(error)
            }
        }
    }
    
    private func updateUnreadNotificationsCount() {
        unreadNotifications = notifications.reduce(0, { $0 + ($1.read ? 0 : 1) })
    }


}
