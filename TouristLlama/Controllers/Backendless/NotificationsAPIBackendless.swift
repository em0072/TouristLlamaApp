//
//  NotificationsAPIBackendless.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation
import SwiftSDK

class NotificationsAPIBackendless: NotificationsAPIProvider {
    
    private let serviceName = "NotificationsService"
    private var channels: [Channel] = []
    private var channelSubscriptions: [RTSubscription?] = []
    
    private var notificationsUpsertSubscription: RTSubscription?

    init() {}
    
    
    func getMyNotifications() async throws -> [UserNotification] {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "getMyNotifications", parameters: nil) { response in
                guard let notificationsArray = response as? [BackendlessUserNotification] else {
                    continuation.resume(throwing: CustomError(text: "Can't cast to array"))
                    return
                }
                let notifications = notificationsArray.compactMap { $0.appObject }
                continuation.resume(returning: notifications)
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func subscribeToNotificationsUpsert(onNewNotification: @escaping (UserNotification) -> Void) {
        guard let currentUserID = Backendless.shared.userService.currentUser?.objectId else { return }
        
        notificationsUpsertSubscription?.stop()
        
        let eventHandler = Backendless.shared.data.ofTable("Notification").rt
        let whereClause = "ownerId = '\(currentUserID)'"
        
        notificationsUpsertSubscription = eventHandler?.addUpsertListener(whereClause: whereClause, responseHandler: { dict in
            guard let id = dict["objectId"] as? String,
                  let ownerId = dict["ownerId"] as? String,
                  let tripId = dict["tripId"] as? String,
                  let title = dict["title"] as? String,
                  let message = dict["message"] as? String,
                  let createdTimeInterval = dict["created"] as? TimeInterval,
                  let read = dict["read"] as? Bool,
                  let typeString = dict["type"] as? String,
                  let type = UserNotification.NotificationType(rawValue: typeString) else { return }
            
            let created = Date(timeIntervalSince1970Milliseconds: createdTimeInterval)

            let userNotification = UserNotification(id: id, ownerId: ownerId, tripId: tripId, title: title, mesage: message, created: created, read: read, type: type)
            onNewNotification(userNotification)
        }, errorHandler: { fault in
            print("Error: \(fault.message ?? "")")
        })
    }
        
    func deleteNotification(id: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = id
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "deleteNotification", parameters: parameters) { _ in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func markNotificationAsRead(id: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let parameters = id
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "markNotificationAsRead", parameters: parameters) { _ in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    func markAllNotificationsAsRead() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Backendless.shared.customService.invoke(serviceName: serviceName, method: "markAllNotificationsAsRead", parameters: nil) { _ in
                continuation.resume(returning: ())
            } errorHandler: { error in
                continuation.resume(throwing: error)
            }
        }

    }
}
