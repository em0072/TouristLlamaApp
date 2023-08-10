//
//  OnboardView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI
import AuthenticationServices

struct OnboardView: View {
        
    @Environment(\.colorScheme) var currentScheme
    
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                VStack {
                    featuresView
                    
                    VStack {
                        buttonsView
                        
                        termsView
                            .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.isTermsAndConditionsShown) {
                TermsAndConditionsView()
                    .presentationDragIndicator(.visible)
            }
            .handle(loading: $viewModel.loadingState)
            .handle(error: $viewModel.error)
        }
    }
    
}

extension OnboardView {
    private var backgroundView: some View {
        Image.Onboarding.loginBG
            .resizable()
            .ignoresSafeArea()
    }
    
    private var featuresView: some View {
        return FeaturesView(features: viewModel.features)
    }
    
    private var buttonsView: some View {
        VStack(spacing: 24) {
            NavigationLink {
                RegisterView()
            } label: {
                Button(String.Onboarding.getStarted) {}
                .buttonStyle(WideBlueButtonStyle())
                .allowsHitTesting(false)
            }
            
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                viewModel.handleSignInAuthorisationResult(result)
            }
            .signInWithAppleButtonStyle(currentScheme == .light ? .black : .white)
            .frame(height: 54)
        }
    }
    
    private var termsView: some View {
        Button {
            viewModel.showTermsAndConditions()
        } label: {
            Text(String.Onboarding.terms)
                .font(.avenirBody)
                .fontWeight(.light)
                .underline()
                .foregroundColor(.Main.black)
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}
