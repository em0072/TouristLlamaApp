//
//  ContentView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct ContentView: View {
    
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
