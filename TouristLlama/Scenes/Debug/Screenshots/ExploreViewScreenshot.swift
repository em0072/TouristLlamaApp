//
//  ExploreViewScreenshot.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/09/2023.
//
#if DEBUG

import SwiftUI
import AspirinShot

extension Screenshot {
    static let explore = Screenshot("Explore View")
}

struct ExploreViewScreenshot: View {
    
    @Environment(\.screenshotFormat) var screenshotFormat
    
    var body: some View {
            ScreenshotView {
                ZStack {
                    VStack {
                        logoWithText
                        text
                        Spacer()
                    }
                    
                    phoneView
                        .scaleEffect(0.8)
                        .offset(x: 0, y: 200)
                        .rotation3DEffect(.degrees(30), axis: (x: -1, y: 1, z: 0), anchor: .center, anchorZ: 0, perspective: -0.9)
                        .environment(\.colorScheme, .dark)
                    
                }
            } background: {
                gradient
            }
    }
    
    private var gradient: LinearGradient {
        LinearGradient(colors: [.Main.strongBlack, .Main.accentBlue], startPoint: .top, endPoint: .bottom)
    }
    
    private var logoWithText: some View {
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .shadow(radius: 3)

                    Text("Tourist Llama")
                    .foregroundColor(.Main.strongWhite)
                    .font(.avenirTitle)
                    .bold()
                
                Spacer()
            }
            .paddingShot(.horizontal, only: [.iPhone_5_5: 30,
                                             .iPhone_6_5: 50,
                                             .iPad_12_9: 80])
            .paddingShot(.top, only: [.iPhone_5_5: 30,
                                      .iPhone_6_5: 50,
                                      .iPad_12_9: 80])
    }
    
    
    
    private var text: some View {
        HStack {
            Text("App that helps you find ")
                .foregroundColor(.Main.strongWhite)
                .font(.avenirHeadline)
                .bold()
            + Text("travel buddies")
                .foregroundColor(.Main.accentBlue)
                .font(.avenirHeadline)
                .bold()
            Spacer()
        }
        .paddingShot(.horizontal, only: [.iPhone_5_5: 30,
                                         .iPhone_6_5: 50,
                                         .iPad_12_9: 80])
    }
    
    @MainActor
    private var phoneView: some View {
        let viewModel = ExploreViewModel()
        viewModel.trips =  [.testParis, .testZermatt, .testAmsterdam]
        viewModel.state = .content
        return ExploreView(viewModel: viewModel)
            .productBezel(inset: false, scaledTo: .fit, statusBar: statusBarConfiguration, backgroundColor: .red)
    }
    
    private var statusBarConfiguration: StatusBarConfiguration {
        .auto(on: .init("statusBarColor"))
    }
}

struct ExploreViewScreenshot_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotPreviews(.explore, in: "en") {
            ExploreViewScreenshot()
        }
    }
}

#endif
