//
//  ContentView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var screenPhase

    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.loginStatus {
            case .notDetermined:
                logoView
                    .transition(.scale.combined(with: .opacity))
            case .loggedOut:
                OnboardView()
            case .loggedIn:
                TabBarView()
                    .onAppear {
                        viewModel.requestNotificationsAuthorization()
//                        viewModel.loadTrips()
                    }
                    .onChange(of: screenPhase, perform: { newScreenPhase in
                        switch newScreenPhase {
                        case .active:
                            viewModel.clearNotificationBadge()
                        default:
                            return
                        }
                    })
            }
        }
        .animation(.default, value: viewModel.loginStatus)
    }
}

extension ContentView {
    
    private var logoView: some View {
        Image.Main.logo
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
