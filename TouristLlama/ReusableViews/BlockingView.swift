//
//  BlockingView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 06/09/2023.
//

import SwiftUI

struct BlockingView: View {
    
    let isLoading: Bool
    let onSubmit: () -> Void
    
    @State var textFieldText: String = ""
    
    var body: some View {
        VStack {
            FieldTitleView(title: String.Main.blockTitle)
            
            Spacer()
            
            Button(action: {
                onSubmit()
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

struct BlockingView_Previews: PreviewProvider {
    static var previews: some View {
        BlockingView(isLoading: true, onSubmit: {})
    }
}
