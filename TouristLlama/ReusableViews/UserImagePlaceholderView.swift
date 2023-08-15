//
//  UserImagePlaceholderView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/08/2023.
//

import SwiftUI

struct UserImagePlaceholderView: View {
    
    private var paddingPercent = 0.2
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Color.Main.grey
                Image(systemName: "person.fill")
                    .resizable()
                    .padding(.horizontal, proxy.size.width * paddingPercent)
                    .padding(.vertical, proxy.size.height * paddingPercent)
                    .foregroundColor(.Main.white)
            }
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        UserImagePlaceholderView()
            .frame(width: 100, height: 100)
    }
}

