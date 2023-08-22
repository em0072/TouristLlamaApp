//
//  EditUsernameView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import Foundation

import SwiftUI
import Combine

struct EditUsernameView: View {
    
    enum UsernameCheckState {
        case none
        case loading
        case available
        case isTaken
    }
    
    @Environment(\.dismiss) var dismiss

//    @ObservedObject var viewModel: EditProfileViewModel
    
    @State var username: String
    let state: UsernameCheckState
    let checkUsernameAction: (String) -> Void
    let onUsernameChange: (String) -> Void

    let textPublisher = PassthroughSubject<String, Never>()

    init(username: String,
         state: UsernameCheckState,
         checkUsernameAction: @escaping (String) -> Void,
         onUsernameChange: @escaping (String) -> Void) {
        self._username = State(initialValue: username)
        self.state = state
        self.checkUsernameAction = checkUsernameAction
        self.onUsernameChange = onUsernameChange
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FramedTextField(title: String.Profile.username,
                            prompt: String.Profile.chooseNickname,
                            value: $username,
                            isLoading: state == .loading,
                            showDeleteButton: false,
                            textInputAutocapitalization: .never)
            .autocorrectionDisabled(true)
            .padding(.vertical, 20)
            
            nicknamePromtView
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationTitle(String.Profile.username)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                doneButton
            }
        })
        .onChange(of: username) { newValue in
            textPublisher.send(newValue)
        }
        .onReceive(textPublisher.debounce(for: 0.3, scheduler: RunLoop.main)) { usernameToCheck in
            checkUsernameAction(usernameToCheck)
        }
    }
    
    @ViewBuilder
    private var nicknamePromtView: some View {
        switch state {
        case .none, .loading:
            Text(String.Profile.usernameLimitText)
                .font(.avenirSmallBody.weight(.medium))
                .foregroundColor(.Main.black)
                .opacity(0.8)
        case .available:
            Text(String.Profile.usernameAvailable)
                .font(.avenirSmallBody.weight(.medium))
                .foregroundColor(.Main.accentBlue)
        case .isTaken:
            Text(String.Profile.usernameTaken)
                .font(.avenirSmallBody.weight(.medium))
                .foregroundColor(.Main.accentRed)
        }
    }
        
    private var doneButton: some View {
        Button(action: {
            onUsernameChange(username)
            dismiss()
        }) {
            Text(String.Main.done)
                .font(.avenirBigBody.weight(.heavy))
        }
        .tint(.Main.accentBlue)
        .disabled(state != .available)
    }

    
}

struct EditNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUsernameView(username: "bob", state: .available, checkUsernameAction: { _ in }, onUsernameChange: { _ in })
    }
}

