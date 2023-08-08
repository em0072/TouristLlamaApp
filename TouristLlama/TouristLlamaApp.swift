//
//  TouristLlamaApp.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI
import SwiftSDK

@main
struct TouristLlamaApp: App {
    init() {
        initBackendless()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension TouristLlamaApp {
    private func initBackendless() {
        Backendless.shared.hostUrl = "https://eu-api.backendless.com"
        Backendless.shared.initApp(applicationId: "107EEFC1-7541-7992-FF48-1F34C1C05900", apiKey: "976589AC-23F7-4A65-A981-0D2B3B5415DF")
    }
}
