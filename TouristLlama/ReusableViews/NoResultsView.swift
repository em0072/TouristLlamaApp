//
//  NoResultsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import SwiftUI

struct NoResultsView: View {
    
    var body: some View {
        VStack {
            Spacer()
            IconPlaceholderView(icon: "location.magnifyingglass",
                                text: String.Main.noResults)
            Spacer()
        }
    }
}

struct NoResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NoResultsView()
    }
}
