//
//  TripChatViewScreenshot.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 18/09/2023.
//
#if DEBUG

import SwiftUI
import AspirinShot

extension Screenshot {
    static let tripChat = Screenshot("Trip Chat View")
}

struct TripChatViewScreenshot: View {
    
    @Environment(\.screenshotFormat) var screenshotFormat
    
    var body: some View {
            ScreenshotView {
                ZStack {
                    VStack {
                        text
                        Spacer()
                    }
                    
                    phoneView
                        .scaleEffect(0.8)
                        .offset(x: 0, y: 100)
                        .rotation3DEffect(.degrees(30), axis: (x: -1, y: -1, z: 0), anchor: .center, anchorZ: 0, perspective: -0.9)
                        .environment(\.colorScheme, .dark)
                    
                }
            } background: {
                gradient
            }
    }
    
    private var gradient: LinearGradient {
        LinearGradient(colors: [.Main.strongBlack, .Main.accentBlue], startPoint: .top, endPoint: .bottom)
    }

    private var text: some View {
        ZStack(alignment: .center) {
            Text("Stay ")
                .foregroundColor(.Main.strongWhite)
                .font(.avenirHeadline)
                .bold()
            + Text("connected")
                .foregroundColor(.Main.accentBlue)
                .font(.avenirHeadline)
                .bold()
            + Text(" with your trip buddies!")
                .foregroundColor(.Main.strongWhite)
                .font(.avenirHeadline)
                .bold()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .paddingShot(.horizontal, only: [.iPhone_5_5: 20,
                                         .iPhone_6_5: 40,
                                         .iPad_12_9: 70])
        .paddingShot(.top, only: [.iPhone_5_5: 30,
                                         .iPhone_6_5: 50,
                                         .iPad_12_9: 80])

    }
    
    @MainActor
    private var phoneView: some View {
        let tripChatViewModel = TripChatViewModel()
        tripChatViewModel.updateChat(with: .testAmsterdam)
        return TripChatView(title: Trip.testAmsterdam.name, viewModel: tripChatViewModel)
            .productBezel(inset: false, scaledTo: .fit, statusBar: statusBarConfiguration, backgroundColor: .clear)
    }
    
    private var statusBarConfiguration: StatusBarConfiguration {
        .auto
    }
}

struct TripChatViewScreenshot_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotPreviews(.trip, in: "en") {
            TripChatViewScreenshot()
        }
    }
}

#endif
