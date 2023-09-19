//
//  DebugView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 15/09/2023.
//

import SwiftUI

struct DebugView: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section("Screenshots") {
                    NavigationLink("Screenshots") {
                        ScreenshotsView()
                    }
                }
            }
            .navigationTitle("Debug Menu")
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
