//
//  BackendlessUserNotification.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

import Foundation

@objcMembers class BackendlessUserNotification: NSObject, BackendlessObject {
    var objectId: String?
    var ownerId: String?
    var tripId: String?
    var title: String?
    var type: String?
    var message: String?
    var created: Date?
    var read: Bool = false
    
    override init() {
        super.init()
    }

    init?(from userNotification: UserNotification?) {
        guard let userNotification else { return nil }
        self.objectId = userNotification.id
        self.ownerId = userNotification.ownerId
        self.tripId = userNotification.tripId
        self.title = userNotification.title
        self.message = userNotification.mesage
        self.created = userNotification.created
        self.read = userNotification.read
        self.type = userNotification.type.rawValue
    }
        
    var appObject: UserNotification? {
        guard let objectId,
              let ownerId,
              let title,
              let message,
              let created,
              let tripId,
              let type,
              let notifiactionType = UserNotification.NotificationType(rawValue: type) else { return nil }
        
        
        return UserNotification(id: objectId, ownerId: ownerId, tripId: tripId, title: title, mesage: message, created: created, read: read, type: notifiactionType)
    }
}
