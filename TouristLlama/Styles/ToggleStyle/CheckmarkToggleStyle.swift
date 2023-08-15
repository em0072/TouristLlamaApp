//
//  CheckmarkToggleStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(Color.Main.accentBlue, style: .init(lineWidth: 1))
                .frame(width: 20, height: 20)
            
            if configuration.isOn {
                Circle()
                    .fill(Color.Main.accentBlue)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.avenirCaption)
                            .bold()
                    }
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeOut(duration: 0.15), value: configuration.isOn)
        .frame(width: 25, height: 25)
        .contentShape(Rectangle())
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
    
}

struct CheckmarkToggleStyleOnRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
        }
    }
}

