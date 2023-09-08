//
//  UserNotification.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

struct UserNotification: Identifiable, Equatable {
    
    enum NotificationType: String {
        case tripUpdate
    }
    
    let id: String
    let ownerId: String
    let tripId: String
    let title: String
    let mesage: String
    let created: Date
    var read: Bool
    let type: NotificationType
    
    var icon: String {
        switch type {
        case .tripUpdate:
            return "airplane" 
        }
    }
    
    mutating func markAsRead() {
        read = true
    }
}
