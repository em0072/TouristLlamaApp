//
//  PasswordRecoveryView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct PasswordRecoveryView: View {
    
    @State var email: String
    
    let onPasswordRecoveryAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleView
            
            descriptionView
            
            textfieldView
            
            buttonView
                .disabled(email.isEmpty)
                .padding(.top, 30)
            
            Spacer()
        }
        .padding(20)
    }
}

extension PasswordRecoveryView {
    
    private var titleView: some View {
        Text(String.Onboarding.passwordRecoveryTitle)
            .font(.avenirHeadline)
            .bold()
    }
    
    private var descriptionView: some View {
        Text(String.Onboarding.passwordRecoveryBody)
            .font(.avenirBody)
    }
    
    private var textfieldView: some View {
        FloatingTextField(title: String.Onboarding.email,
                          value: $email,
                          foregroundColor: .Main.black,
                          placeholderColorActive: .Main.grey,
                          keyboardType: .emailAddress)
        .withDivider(colored: .Main.grey)
    }
    
    private var buttonView: some View {
        Button(String.Onboarding.passwordRecoveryButton) {
            onPasswordRecoveryAction()
        }
        .buttonStyle(WideBlueButtonStyle())
    }
}




struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView(email: "email@mail.com") {}
    }
}
