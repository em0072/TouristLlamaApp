//
//  Dependencies.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import Foundation
import Dependencies

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
