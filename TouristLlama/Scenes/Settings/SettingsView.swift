//
//  SettingsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import SwiftUI

struct SettingsView: View {
    

    @StateObject var viewModel: SettingsViewModel = .init()
    
    var body: some View {
        ScrollView {
            VStack {
                settingsInfoView
                
                logoutButton
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(String.Profile.settingsTitle)
        .confirmationDialog(String.Profile.logoutPromptTitle,
                            isPresented: $viewModel.isLogoutConfirmationShown,
                            actions: { logoutConfirmationDialogActions },
                            message: { logoutConfirmationDialogMessage })
    }
    
}

extension SettingsView {
    private var settingsInfoView: some View {
        Text("Settings will be completed soon")
            .padding(.vertical, 100)
    }
    
    
    private var logoutButton: some View {
        ZStack {
            FieldBackgroundView()
            Button {
                viewModel.logoutButtonAction()
            } label: {
                Text(String.Profile.logout)
                    .font(.avenirBody)
                    .foregroundColor(.Main.accentRed)
            }
        }
    }
    
    @ViewBuilder
    private var logoutConfirmationDialogActions: some View {
        Button(String.Profile.logout, role: .destructive) {
            viewModel.logout()
        }
        Button(String.Main.cancel, role: .cancel) {}
    }
    
    private var logoutConfirmationDialogMessage: some View {
        Text(String.Profile.logoutPromptMessage)
            .font(.avenirBody)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
