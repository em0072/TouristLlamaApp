//
//  NotificationsAPIProvider.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

protocol NotificationsAPIProvider {
    func getMyNotifications() async throws -> [UserNotification]
    func subscribeToNotificationsUpsert(onNewNotification: @escaping (UserNotification) -> Void)
    func deleteNotification(id: String) async throws
    func markNotificationAsRead(id: String) async throws
    func markAllNotificationsAsRead() async throws
}
