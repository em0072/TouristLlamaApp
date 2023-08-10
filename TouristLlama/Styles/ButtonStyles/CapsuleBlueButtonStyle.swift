//
//  CapsuleBlueButtonStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct CapsuleBlueButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.Main.TLStrongWhite)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background {
                Capsule()
                    .fill(Color.Main.accentBlue)
            }
    }
}

struct CapsuleBlueButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Test") {
            
        }
        .buttonStyle(CapsuleBlueButtonStyle())
    }
}
