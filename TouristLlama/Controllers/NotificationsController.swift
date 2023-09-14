//
//  NotificationsController.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 30/08/2023.
//

import SwiftUI
import Combine
import UserNotifications
import UserNotificationsUI
import Dependencies

final class NotificationsController: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Dependency(\.tripsController) var tripsController
    @Dependency(\.notificationsAPI) var notificationsAPI

    @Published var isShowingSettingsPage = false
    @Published var badgeNumber = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        clearBadge()
        $badgeNumber
            .drop(while: {$0 < 0})
            .sink { badgeNumber in
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        }.store(in: &cancellables)
    }
    
    func requestPushNotificationAuthorization() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [
                    .alert,
                    .sound,
                    .badge])
                
            } catch {
                print(error)
            }
        }
    }
    
    func clearBadge() {
        badgeNumber = 0
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        isShowingSettingsPage = true
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(response)
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response)
        guard let type = response.notification.request.content.userInfo["type"] as? String,
              let tripId = response.notification.request.content.userInfo["tripId"] as? String,
              let trip = try? await tripsController.getTrip(tripId: tripId) else {
            return
        }
        if let notificationId = response.notification.request.content.userInfo["notificationId"] as? String {
            notificationsAPI.markNotificationAsRead(id: notificationId)
        }
        if type == "chatUpdate" {
            tripsController.open(tripOpenState: .chat(trip))
        } else if type == "tripUpdate" {
            tripsController.open(tripOpenState: .details(trip))
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print(notification)
        let notificationShownOptions: UNNotificationPresentationOptions = [.badge, .banner, .sound]
        let notificationNotShownOptions: UNNotificationPresentationOptions = []
        
        guard let type = notification.request.content.userInfo["type"] as? String,
              let tripId = notification.request.content.userInfo["tripId"] as? String else {
            return notificationShownOptions
        }
        if type == "chatUpdate" && tripsController.selectedTripState?.id == tripId {
            return notificationNotShownOptions
        }
        return notificationShownOptions
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        guard let message = userInfo["ios-alert"] as? String else {
//            completionHandler(.failed)
//            return
//        }
//        let title = userInfo["title"] as? String ?? ""
//        let tripId = userInfo["tripId"] as? String ?? ""
//        print(userInfo)
//        completionHandler(.newData)
//    }

}
