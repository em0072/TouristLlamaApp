//
//  LogInView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct LogInView: View {
    
    @Environment(\.dismiss) var dismiss
    
    enum FocusField: Hashable {
        case email
        case password
      }

    @StateObject private var viewModel: LogInViewModel = LogInViewModel()
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                titleView
                
                fieldsView
                
                forgotPasswordView
                    .padding(.vertical, 30)
                
                logInButton
                
                Spacer()
                
                registerButton
            }
            .padding(.horizontal, 20)
            .navigationTitle("")
        }
        .sheet(isPresented: $viewModel.isPasswordRecoveryShown) {
            PasswordRecoveryView(email: viewModel.email) {
                viewModel.recoverPassword()
            }
            .presentationDragIndicator(.visible)
            .handle(loading: $viewModel.loadingState)
            .handle(error: $viewModel.error)
        }
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
    }
}

extension LogInView {
    
    private var backgroundView: some View {
        Image.Onboarding.registrationBG
            .resizable()
            .opacity(0.3)
            .ignoresSafeArea()
    }
    
    private var titleView: some View {
        HStack {
            Text(String.Onboarding.loginTitle)
                .font(.avenirHeadline)
                .bold()
            Spacer()
        }
    }
    
    private var fieldsView: some View {
        VStack(spacing: 20) {
            FloatingTextField(title: String.Onboarding.email,
                              value: $viewModel.email,
                              foregroundColor: .Main.black,
                              placeholderColorActive: .Main.black,
                              keyboardType: .emailAddress)
                .withDivider()
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }
            FloatingTextField(title: String.Onboarding.password,
                              value: $viewModel.password,
                              foregroundColor: .Main.black,
                              placeholderColorActive: .Main.black,
                              secure: true)
                .withDivider()
                .focused($focusedField, equals: .password)
                .submitLabel(.done)

        }
    }
    
    private var forgotPasswordView: some View {
        HStack {
            Spacer()
            Button {
                viewModel.showPasswordRecovery()
            } label: {
                Text(String.Onboarding.forgotPasswordPrompt)
                    .font(.avenirBody)
                    .foregroundColor(.Main.black)
            }
        }
    }

    private var logInButton: some View {
        Button(String.Onboarding.logIn) {
            viewModel.login()
        }
        .buttonStyle(WideBlueButtonStyle())
        .disabled(viewModel.isLoginButtonDisabled)
    }

    private var registerButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Text(String.Onboarding.noAccountPrompt)
                Text(String.Onboarding.register)
                    .bold()
                    .underline()
            }
            .font(.avenirBody)
            .foregroundColor(.Main.black)

        }

    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LogInView()
        }
    }
}
