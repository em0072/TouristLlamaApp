//
//  FieldBackgroundView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FieldBackgroundView: View {
    
    let height: CGFloat
    let fillColor: Color
    let shadowStyle: ShadowStyle?
    
    init(height: CGFloat = 54, fillColor: Color? = nil, shadowStyle: ShadowStyle? = nil) {
        self.height = height
        self.fillColor = fillColor ?? Color.Main.TLBackgroundActive
        self.shadowStyle = shadowStyle
        
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(fillStyle)
            .frame(height: height)
//            .foregroundStyle(fillColor.shadow(.inner(color: .Main.black, radius: 3, x: 0, y: 0)))
    }
    
    private var fillStyle: some ShapeStyle {
        if let shadowStyle {
            return fillColor.shadow(shadowStyle)
        } else {
            return fillColor.shadow(.drop(color: .clear, radius: 0, x: 0, y: 0))
        }
    }
}

struct FieldBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        FieldBackgroundView()
    }
}
