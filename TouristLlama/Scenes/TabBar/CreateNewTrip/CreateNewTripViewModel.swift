//
//  CreateNewTripViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import SwiftUI

class CreateNewTripViewModel: ViewModel {
        
    @Published var currentCreationStage: TripCreationStage = .generalInfo {
        willSet {
            previousCreationStage = currentCreationStage
        }
    }
    var previousCreationStage: TripCreationStage = .generalInfo
    @Published var finishedCreationStages: Set<TripCreationStage> = []
    @Published var tripName: String = ""
    @Published var tripStyle: TripStyle = .none
    @Published var tripLocation: TripLocation?
    @Published var tripStartDate: Date?
    @Published var tripEndDate: Date?
    @Published var tripDescription: String = ""
    @Published var tripPhoto: TripPhoto?
    @Published var isTripPublic: Bool = true
    
    override init() {
        super.init()
        finishedCreationStages.insert(.generalInfo)
    }
    
    func onButtonAction() {
        switch currentCreationStage {
        case .generalInfo:
            currentCreationStage = .description
        case .description:
            currentCreationStage = .photo
        case .photo:
            currentCreationStage = .settings
        case .settings:
            createTrip()
        }
        finishedCreationStages.insert(currentCreationStage)

    }
    
    func createTrip() {
        
    }
    
    var isButtonDisabled: Bool {
        return false
        switch currentCreationStage {
        case .generalInfo:
            return tripName.isEmpty || tripStyle == .none || tripLocation == nil || tripStartDate == nil || tripEndDate == nil
        case .description:
            return tripDescription.isEmpty
        case .photo:
            return tripPhoto == nil
        case .settings:
            return false
        }

    }
    
    func transition(previous: TripCreationStage) -> AnyTransition {
        print(currentCreationStage, previousCreationStage)
        switch (currentCreationStage, previousCreationStage) {
        case (.generalInfo, _):
            return .move(edge: .leading)
            
        case (.description, .generalInfo):
            return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing))

        case (.description, _):
            return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
            
        case (.photo, .settings):
            return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))

        case (.photo, _):
            return .move(edge: .trailing)

        case (.settings, _):
            return .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))

        }
    }
}
