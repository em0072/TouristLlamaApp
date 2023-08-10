//
//  SelectorIconView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct SelectorIconView: View {
    
    var color: Color = .Main.black
    
    var body: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .aspectRatio(contentMode: .fit)
            .font(.system(size: 10))
            .foregroundColor(color)
    }
    
    func iconText(_ color: Color) -> some View {
        SelectorIconView(color: color)
    }
}

struct SelectorIconView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorIconView()
    }
}


