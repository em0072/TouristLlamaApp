//
//  TripApplicationForm.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import SwiftUI

struct TripApplicationForm: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var applicationLetter: String = ""

    
    let onRequestSend: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(String.Trip.requestApplicationLetterSubtitle)
                    .font(.avenirBody)
                
                FramedTextView(title: nil, prompt: String.Trip.requestApplicationLetterPrompt, value: $applicationLetter, charactersLimit: 300)
                
                Spacer()
                
                sendRequestButtonView
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            .navigationTitle(String.Trip.requestApplicationLetterTitle)
        }
    }
    
}

extension TripApplicationForm {
    
    var sendRequestButtonView: some View {
        Button(String.Trip.requestToJoinSend) {
            onRequestSend(applicationLetter)
        }
        .buttonStyle(WideBlueButtonStyle())
    }
}

struct TripApplicationForm_Previews: PreviewProvider {
    static var previews: some View {
        TripApplicationForm(onRequestSend: {_ in })
    }
}
