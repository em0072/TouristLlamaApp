//
//  ReportingView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 05/09/2023.
//

import SwiftUI

struct ReportingView: View {
    
    let isLoading: Bool
    let onSubmit: (String) -> Void
    
    @State var textFieldText: String = ""
    
    var body: some View {
        VStack {
            FramedTextView(title: String.Main.reportReason, prompt: String.Main.reportReasonPromt, value: $textFieldText)
            
            Spacer()
            
            Button(action: {
                onSubmit(textFieldText)
            }, label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.Main.strongWhite)
                } else {
                    Text(String.Main.submit)
                }
            })
            .buttonStyle(WideBlueButtonStyle())
            .disabled(textFieldText.isEmpty || isLoading)
        }
        .padding(20)
    }
}

struct ReportingView_Previews: PreviewProvider {
    static var previews: some View {
        ReportingView(isLoading: false, onSubmit: { _ in })
    }
}
