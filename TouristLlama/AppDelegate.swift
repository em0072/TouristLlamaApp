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

class AppDelegate: NSObject, UIApplicationDelegate {
        
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
    
    
}
