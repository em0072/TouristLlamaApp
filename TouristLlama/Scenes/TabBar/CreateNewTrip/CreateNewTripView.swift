//
//  CreateNewTripView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct CreateNewTripView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = CreateNewTripViewModel()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.currentCreationStage) {
                GeneralInfoStageView(name: $viewModel.tripName,
                                     tripStyle: $viewModel.tripStyle,
                                     tripLocation: $viewModel.tripLocation)
                    .tag(CreateNewTripViewModel.TripCreationStage.generalInfo)
            }
            .navigationTitle(String.MyTrips.createTripTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                closeButton
            }
        }
    }
}

extension CreateNewTripView {
    
    private var closeButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
        }
    }
    
    
}

struct CreateNewTripView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTripView()
    }
}
