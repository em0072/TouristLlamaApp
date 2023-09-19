//
//  ContentViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import Foundation
import Dependencies
import SwiftSDK
import UserNotifications
import UIKit

class ContentViewModel: ViewModel {
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.notificationsController) var notificationsController
//    @Dependency(\.tripsController) var tripsController

    enum LoginStatus {
        case notDetermined
        case loggedOut
        case loggedIn
    }
    
    @Published var loginStatus: LoginStatus = .notDetermined
        
    override func subscribeToUpdates() {
        userAPI.$currentUser
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] currentUser in
                self?.loginStatus = currentUser == nil ? .loggedOut : .loggedIn
            }
            .store(in: &publishers)
    }
    
    func requestNotificationsAuthorization() {
        notificationsController.requestPushNotificationAuthorization()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            Task { @MainActor in
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
//    func loadTrips() {
//        tripsController.loadTrips()
//    }
}

