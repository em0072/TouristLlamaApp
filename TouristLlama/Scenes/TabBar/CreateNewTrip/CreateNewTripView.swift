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
                    .transition(.asymmetric(insertion: .move(edge: .trailing),
                                            removal: .move(edge: .leading)))

                case .description:
                    DescriptionStageView(description: $viewModel.tripDescription)
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading)))

                case .photo:
                    PhotoStageView(searchQuery: viewModel.tripLocation?.title ?? "World",
                                   tripPhoto: $viewModel.tripPhoto)
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading)))

                case .settings:
                    SettingsStageView(isVisible: $viewModel.isTripPublic)
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
            .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
            .handle(error: $viewModel.error)
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
        Button(viewModel.buttonText) {
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
