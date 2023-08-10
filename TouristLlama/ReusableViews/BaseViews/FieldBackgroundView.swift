//
//  FieldBackgroundView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct FieldBackgroundView: View {
    
    let height: CGFloat
    
    init(height: CGFloat = 54) {
        self.height = height
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.Main.TLBackgroundActive)
            .frame(height: height)
    }
    
}

struct FieldBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        FieldBackgroundView()
    }
}
