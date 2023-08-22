//
//  FramedButtonStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import SwiftUI

struct FramedButtonStyle: ButtonStyle {
    
    @Binding var value: String
        
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 8) {
            HStack {
                configuration.label
                    .lineLimit(1)
                    .font(.avenirBody)
                    .bold()
                Spacer()
            }
            .allowsHitTesting(false)
            
            FieldBackgroundView()
                .overlay {
                    HStack {
                        if value.isEmpty {
                            configuration.label
                                .lineLimit(1)
                                .font(.avenirBody)
                                .foregroundColor(.Main.TLInactiveGrey)
                        } else {
                            Text(value)
                                .lineLimit(1)
                                .font(.avenirBody)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
}


struct FramedButtonStyle_Preview: PreviewProvider {
    static var previews: some View {
        Button("Test") {
            
        }
        .buttonStyle(FramedButtonStyle(value: .constant("hey")))
    }
}
