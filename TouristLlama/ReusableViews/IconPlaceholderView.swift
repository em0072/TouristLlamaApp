//
//  IconPlaceholderView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct IconPlaceholderView: View {
    
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.avenirHeadline)
            HStack {
                Spacer()
                Text(text)
                    .font(.avenirBigBody)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
}

struct IconPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        IconPlaceholderView(icon: "location.magnifyingglass", text: "No results")
    }
}

