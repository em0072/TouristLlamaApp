//
//  Dependencies.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation
import Dependencies

// MARK: - UserAPIKey
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

// MARK: - TripsAPIKey
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

