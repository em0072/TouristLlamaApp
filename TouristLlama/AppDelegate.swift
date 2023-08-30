//
//  AppDelegate.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import Foundation
import UIKit
import Combine
import SwiftSDK
import UserNotifications

struct Notification: Identifiable {
    let id: UUID = .init()
    let message: String
    let onTapAction: () -> Void
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let notitficationPublished: PassthroughSubject<Notification, Never> = .init()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setUpNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Backendless.shared.messaging.registerDevice(deviceToken: deviceToken, responseHandler: { registrationId in
           print("Device has been registered in Backendless")
        }, errorHandler: { fault in
           print("Error: \(fault.message ?? "")")
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    
    private func setUpNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let message = userInfo["ios-alert"] as? String else {
            completionHandler(.failed)
            return
        }
        let tripId = userInfo["tripId"] as? String ?? ""
        let notitfication = Notification(message: message, onTapAction: {
            print(tripId)
        })
        notitficationPublished.send(notitfication)
        completionHandler(.newData)
    }
}
