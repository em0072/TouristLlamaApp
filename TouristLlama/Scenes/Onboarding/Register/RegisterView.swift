//
//  RegisterView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct RegisterView: View {
    
    enum FocusField: Hashable {
        case name
        case email
        case password
    }
    
    @StateObject private var viewModel: RegisterViewModel = RegisterViewModel()
    
    @FocusState private var focusedField: FocusField?

    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                titleView
                
                fieldsView
                
                termsView
                    .padding(.top, 12)
                
                Spacer()
                
                registerButtonView
                    .disabled(viewModel.isRegisterButtonDisabled)
                
                loginButtonView
            }
            .padding(.horizontal, 20)
            .navigationTitle("")
            .navigationDestination(isPresented: $viewModel.isLoginShown) {
                LogInView()
            }
            .sheet(item: $viewModel.sheetType, content: sheetView)
        }
        .ignoresSafeArea(.keyboard)
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
    }
}

extension RegisterView {
    private var backgroundView: some View {
        Image.Onboarding.registrationBG
            .resizable()
            .opacity(0.3)
            .ignoresSafeArea()
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(String.Onboarding.registerTitle)
                .font(.avenirHeadline)
                .fontWeight(.heavy)
            
            Text(String.Onboarding.registerSubtitle)
                .font(.avenirBody)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.Main.black)
        }
    }
    
    private var fieldsView: some View {
        VStack(spacing: 20) {
            FloatingTextField(title: String.Onboarding.fullName, value: $viewModel.name,
                              foregroundColor: .Main.black,
                              placeholderColorActive: .Main.black)
            .withDivider(colored: .Main.black)
            .focused($focusedField, equals: .name)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .email
            }
            
            FloatingTextField(title: String.Onboarding.email, value: $viewModel.email,
                              foregroundColor: .Main.black,
                              placeholderColorActive: .Main.black,
                              keyboardType: .emailAddress)
                .withDivider(colored: .Main.black)
            .focused($focusedField, equals: .email)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .password
            }
            
            FloatingTextField(title: String.Onboarding.password, value: $viewModel.password,
                              foregroundColor: .Main.black,
                              placeholderColorActive: .Main.black,
                              secure: true)
                .withDivider(colored: .Main.black)
            .focused($focusedField, equals: .password)
            .keyboardType(.default)
            .submitLabel(.done)
        }
    }
    
    
    private var termsView: some View {
            Toggle(isOn: $viewModel.termsAccepted) {
                HStack(spacing: 6) {
                    Text(String.Onboarding.acceptTermsText)
                        .font(.avenirSmallBody)
                    Button {
                        viewModel.showTermsAndConditions()
                    } label: {
                        Text(String.Onboarding.terms)
                            .font(.avenirSmallBody)
                            .bold()
                            .underline()
                    }
                }
            }
            .toggleStyle(SwitchToggleStyle(size: .small))
    }
    
    private var registerButtonView: some View {
        Button(String.Onboarding.register) {
            viewModel.registerNewUser()
        }
        .buttonStyle(WideBlueButtonStyle())
    }
    
    private var loginButtonView: some View {
        Button {
            viewModel.showLoginView()
        } label: {
            HStack {
                Text(String.Onboarding.alreadyHaveAccount)
                Text(String.Onboarding.logIn)
                    .bold()
                    .underline()
            }
            .font(.avenirBody)
            .foregroundColor(.Main.black)
            .padding(.top, 30)
        }
    }
    
    @ViewBuilder
    private func sheetView(for type: RegisterViewModel.SheetType) -> some View {
        switch type {
        case .emailConfirmation:
            EmailConfirmationView {
                viewModel.showLoginView()
            } resendAction: {
                viewModel.resendEmailConfirmation()
            }
            .presentationDragIndicator(.visible)
            .handle(loading:  $viewModel.loadingState)

        case .termsAndConditions:
            TermsAndConditionsView()
                .presentationDragIndicator(.visible)
        }
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
        }
    }
}
