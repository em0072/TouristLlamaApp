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
    
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
        let features = OnboardingFeaturesBuilder().build()
        return FeaturesView(features: features)
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
                
            } onCompletion: { result in
                
            }
            .signInWithAppleButtonStyle(currentScheme == .light ? .black : .white)
            .frame(height: 54)
        }
    }
    
    private var termsView: some View {
        Button {
            
        } label: {
            Text("Terms & Conditions")
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
