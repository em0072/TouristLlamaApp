//
//  EmailConfirmationView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/08/2023.
//

import SwiftUI

struct EmailConfirmationView: View {
    
    @Environment(\.dismiss) var dismiss

    let loginAction: () -> Void
    let resendAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            titleView
            
            descriptionView
            
            resendEmailView
            
            buttonView
        }
        .padding(.horizontal, 20)
    }
}

extension EmailConfirmationView {
    
    private var titleView: some View {
        Text(String.Onboarding.emailConfirmationTitle)
            .font(.avenirHeadline)
            .multilineTextAlignment(.center)
    }
    
    private var descriptionView: some View {
        Text(String.Onboarding.emailConfirmationBody)
            .font(.avenirBody)
            .multilineTextAlignment(.center)
    }
    
    private var resendEmailView: some View {
        HStack(spacing: 5) {
            Text(String.Onboarding.emailConfirmationResendPrompt)
                .font(.avenirCaption)
            Button {
                resendAction()
            } label: {
                Text(String.Onboarding.emailConfirmationResendButton)
                .font(.avenirCaption)
                .foregroundColor(.Main.black)
                .fontWeight(.black)
            }
        }
    }
    
    private var buttonView: some View {
        Button(String.Onboarding.logIn) {
            loginAction()
            dismiss()
        }
        .buttonStyle(WideBlueButtonStyle())
    }
}

struct EmailConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailConfirmationView(loginAction: {}, resendAction: {})
    }
}
