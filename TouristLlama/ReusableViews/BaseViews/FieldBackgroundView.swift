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
    
    init(height: CGFloat = 54, fillColor: Color? = nil) {
        self.height = height
        self.fillColor = fillColor ?? Color.Main.TLBackgroundActive
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(fillColor)
            .frame(height: height)
    }
    
}

struct FieldBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        FieldBackgroundView()
    }
}
