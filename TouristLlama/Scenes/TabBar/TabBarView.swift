//
//  TabBarView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var viewModel = TabBarViewModel()
    
    var body: some View {
        Button("Logout") {
            viewModel.logout()
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
