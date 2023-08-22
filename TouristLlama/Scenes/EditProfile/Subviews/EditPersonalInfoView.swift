//
//  EditPersonalInfoView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import SwiftUI

struct EditPersonalInfoView: View {
        
    @Binding var email: String
    @Binding var phone: String
    @Binding var dateOfBirth: Date?
    
    var body: some View {
        VStack(spacing: 24) {
            FramedTextField(title: String.Profile.email,
                            prompt: String.Profile.email,
                            value: $email,
                            showDeleteButton: false)
                .disabled(true)
            
            FramedTextField(title: String.Profile.phoneNumber,
                            prompt: String.Profile.phoneNumber,
                            value: $phone,
                            showDeleteButton: false)

            FramedDatePickerView(title: String.Profile.dateOfBirth,
                                 placeholder: String.Profile.dateOfBirth,
                                 selection: $dateOfBirth,
                                 maximumDate: Date.forward(.years(-18)))
            Spacer()
        }
        .padding([.horizontal, .top], 20)
    }
}

struct EditPersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPersonalInfoView(email: .constant("em0072@gmail.com"), phone: .constant("0651704915"), dateOfBirth: .constant(Date.forward(.years(-30))))
    }
}
