//
//  NotificationsAPIMock.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

class NotificationsAPIMock: NotificationsAPIProvider {
        
    func getMyNotifications() async throws -> [UserNotification] {
        return [.test, .testRead]
    }
    
    func subscribeToNotificationsUpdates(onNewNotification: @escaping (UserNotification) -> Void) {
        
    }
    
    func deleteNotification(id: String) async throws {
        
    }
    
    func markNotificationAsRead(id: String) async throws {
        
    }
    
    func markAllNotificationsAsRead() async throws {
        
    }
    
}
