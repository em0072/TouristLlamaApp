//
//  WideBlueButtonStyle.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 07/08/2023.
//

import SwiftUI

struct WideBlueButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let textColor: Color
    let font: Font
    let fontWeight: Font.Weight

    init() {
        self.cornerRadius = 8
        self.backgroundColor = .Main.accentBlue
        self.textColor = .white
        self.font = .avenirBody
        self.fontWeight = .heavy
    }
    
    init(cornerRadius: CGFloat, backgroundColor: Color, textColor: Color, font: Font, fontWeight: Font.Weight) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.fontWeight = fontWeight
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(font)
                .fontWeight(fontWeight)
                .foregroundColor(textColor)
                .frame(height: 54)
            Spacer()
        }
        .contentShape(Rectangle())
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .opacity(buttonOpacity(isPressed: configuration.isPressed, isEnabled: isEnabled))
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension WideBlueButtonStyle {
    private func buttonOpacity(isPressed: Bool, isEnabled: Bool) -> CGFloat {
        if isPressed {
            return 0.7
        }
        if !isEnabled {
            return 0.5
        }
        return 1
    }
}

struct WideBlueButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Test") {
            
        }
        .buttonStyle(WideBlueButtonStyle())
    }
}
