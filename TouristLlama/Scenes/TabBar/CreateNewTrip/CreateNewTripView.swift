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
            VStack {
                StageSelector(allStages: TripCreationStage.allCases,
                              currentStage: $viewModel.currentCreationStage,
                              allowedStages: viewModel.finishedCreationStages)
                .padding(.horizontal, 20)

                switch viewModel.currentCreationStage {
                case .generalInfo:
                    GeneralInfoStageView(name: $viewModel.tripName,
                                         tripStyle: $viewModel.tripStyle,
                                         tripLocation: $viewModel.tripLocation,
                                         startDate: $viewModel.tripStartDate,
                                         endDate: $viewModel.tripEndDate)
//                    .transition(.move(edge: .leading))
                    .transition(.asymmetric(insertion: .move(edge: .trailing),
                                            removal: .move(edge: .leading)))
                    
                case .description:
                    DescriptionStageView(description: $viewModel.tripDescription)
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading)))

                case .photo:
                    Text("Photo")
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading)))

                case .settings:
                    Text("Settings")
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading)))
                }
                
                Spacer()
                
                submitButtonView
                    .padding(.horizontal, 20)
            }
            .animation(.default, value: viewModel.currentCreationStage)
            .navigationTitle(String.MyTrips.createTripTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                closeButton
            }
//            .onChange(of: viewModel.currentCreationStage) { [currentCreationStage =  viewModel.currentCreationStage] newValue in
//                viewModel.previousCreationStage = currentCreationStage
//            }
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
    
    private var submitButtonView: some View {
        Button(String.Main.continue) {
            viewModel.onButtonAction()
        }
        .buttonStyle(WideBlueButtonStyle())
        .disabled(viewModel.isButtonDisabled)
    }
    
}

struct CreateNewTripView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTripView()
    }
}
