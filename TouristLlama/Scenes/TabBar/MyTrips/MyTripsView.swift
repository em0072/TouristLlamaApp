//
//  MyTripsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct MyTripsView: View {
    
    @StateObject var viewModel = MyTripsViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle(String.MyTrips.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(String.MyTrips.createTripButton) {
                            viewModel.startCreationOfNewTrip()
                        }
                        .buttonStyle(CapsuleBlueButtonStyle())
                    }
                }
        }
        .sheet(isPresented: $viewModel.isShowingNewTripCreation) {
            CreateNewTripView()
                .interactiveDismissDisabled()
        }
    }
}


struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}
