//
//  CreateNewTripViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

class CreateNewTripViewModel: ViewModel {
    
    enum TripCreationStage {
        case generalInfo
        case description
        case photo
        case settings
    }
    
    @Published var currentCreationStage: TripCreationStage = .generalInfo
    @Published var tripName: String = ""
    @Published var tripStyle: TripStyle = .none
    @Published var tripLocation: TripLocation?
    @Published var tripStartDate: Date?
    @Published var tripEndDate: Date?
    @Published var tripDescription: String = ""
    @Published var tripPhoto: TripPhoto?
    @Published var isTripPublic: Bool = true

}
