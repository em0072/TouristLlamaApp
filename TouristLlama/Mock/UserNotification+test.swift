//
//  UserNotification+test.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

extension UserNotification {
    
    static var test: UserNotification {
        let author = User.test
        return UserNotification(id: UUID().uuidString, ownerId: author.id, tripId: Trip.testFuture.id, title: "New Invite", mesage: "You are invited To join the trip", created: Date(), read: false, type: .tripUpdate)
    }
    
    static var testRead: UserNotification {
        let author = User.test
        return UserNotification(id: UUID().uuidString, ownerId: author.id, tripId: Trip.testFuture.id, title: "New Invite", mesage: "You are invited To join the trip", created: Date(), read: true, type: .tripUpdate)
    }


}
