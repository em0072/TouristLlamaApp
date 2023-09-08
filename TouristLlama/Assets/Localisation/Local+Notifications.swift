//
//  Local+Notifications.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import Foundation

extension String {
    
    enum Notifications {
        static let title = String.localized("notificationsTitle")
        static let markAllAsRead = String.localized("notificationsMarkAllAsRead")

    }
    
    
    private static func localized(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key,
                                           value: nil,
                                           table: "Local+Notifications")
    }
}
