//
//  ScreenshotsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/09/2023.
//
#if DEBUG
import SwiftUI
import AspirinShot


struct ScreenshotsView: View {
    var body: some View {
        AspirinShotPreview(screenshots: [.explore, .trip, .tripCreate, .tripChat], userID: "em0072@gmail.com") { screenshot in
            switch screenshot {
            case .explore:
                ExploreViewScreenshot()
            case.trip:
                TripViewScreenshot()
            case .tripCreate:
                TripCreateViewSnapshot()
            case .tripChat:
                TripChatViewScreenshot()
            default:
                EmptyView()
            }
        }
    }
}

struct ScreenshotsView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotsView()
    }
}
#endif
