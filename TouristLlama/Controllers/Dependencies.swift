//
//  Dependencies.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation
import Dependencies

// MARK: - UserAPI
private enum UserAPIKey: DependencyKey {
    static let liveValue = UserAPI(provider: UserAPIBackendless())
    static let previewValue = UserAPI(provider: UserAPIMock())
}

extension DependencyValues {
    var userAPI: UserAPI {
        get { self[UserAPIKey.self] }
        set { self[UserAPIKey.self] = newValue }
    }
}

// MARK: - TripsAPI
private enum TripsAPIKey: DependencyKey {
    static let liveValue = TripsAPI(provider: TripsAPIBackendless())
    static let previewValue = TripsAPI(provider: TripsAPIMock())
}

extension DependencyValues {
    var tripsAPI: TripsAPI {
        get { self[TripsAPIKey.self] }
        set { self[TripsAPIKey.self] = newValue }
    }
}

// MARK: - ChatAPI
private enum ChatAPIKey: DependencyKey {
    static let liveValue = ChatAPI(provider: ChatAPIBackendless())
    static let previewValue = ChatAPI(provider: ChatAPIMock())
}

extension DependencyValues {
    var chatAPI: ChatAPI {
        get { self[ChatAPIKey.self] }
        set { self[ChatAPIKey.self] = newValue }
    }
}

// MARK: - NotificationsAPI
private enum NotificationsAPIKey: DependencyKey {
    static let liveValue = NotificationsAPI(provider: NotificationsAPIBackendless())
    static let previewValue = NotificationsAPI(provider: NotificationsAPIMock())
}

extension DependencyValues {
    var notificationsAPI: NotificationsAPI {
        get { self[NotificationsAPIKey.self] }
        set { self[NotificationsAPIKey.self] = newValue }
    }
}

// MARK: - Pexel Service
private enum PexelServiceKey: DependencyKey {
    static let liveValue = PexelService()
    static let previewValue = PexelService()
}

extension DependencyValues {
    var pexelService: PexelService {
        get { self[PexelServiceKey.self] }
        set { self[PexelServiceKey.self] = newValue }
    }
}

// MARK: - Notifications Controller
private enum NotificationsControllerKey: DependencyKey {
    static let liveValue = NotificationsController()
    static let previewValue = NotificationsController()
}

extension DependencyValues {
    var notificationsController: NotificationsController {
        get { self[NotificationsControllerKey.self] }
        set { self[NotificationsControllerKey.self] = newValue }
    }
}

// MARK: - UserDefaults Controller
private enum UserDefaultsControllerKey: DependencyKey {
    static let liveValue = UserDefaultsController()
    static let previewValue = UserDefaultsController()
}

extension DependencyValues {
    var userDefaultsController: UserDefaultsController {
        get { self[UserDefaultsControllerKey.self] }
        set { self[UserDefaultsControllerKey.self] = newValue }
    }
}

