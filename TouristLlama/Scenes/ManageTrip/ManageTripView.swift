//
//  ManageTripView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct ManageTripView: View {
    
    @Environment(\.dismiss) var dismiss
//    @Environment(\.isAspirinShot) var isAspirinShot

    @StateObject var viewModel: ManageTripViewModel
    
    init(mode: ManageTripViewModel.Mode, onSubmit: ((Trip) -> Void)? = nil) {
        self._viewModel = StateObject(wrappedValue: ManageTripViewModel(mode: mode, onSubmit: onSubmit))
    }
    
    init(viewModel: ManageTripViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
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
            .animation(.default, value: viewModel.tripStyle)
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                closeButton
            }
            .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
//            .onAppear {
//                viewModel.prepareForScreenshot(isInScreenshot: isAspirinShot)
//            }
            .handle(error: $viewModel.error)
        }
    }
}


extension ManageTripView {
    
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
        Button {
            viewModel.onButtonAction()
        } label: {
            if viewModel.isRequestInProgress {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Text(viewModel.buttonText)
            }
        }

//        Button(viewModel.buttonText) {
//            viewModel.onButtonAction()
//        }
        .buttonStyle(WideBlueButtonStyle())
        .disabled(viewModel.isButtonDisabled)
    }
    
}

struct ManageTripView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTripView(mode: .create)
    }
}
