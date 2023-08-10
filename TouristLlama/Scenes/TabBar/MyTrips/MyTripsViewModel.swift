//
//  MyTripsViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation

class MyTripsViewModel: ViewModel {
    
    @Published var isShowingNewTripCreation = false
    
    func startCreationOfNewTrip() {
        isShowingNewTripCreation = true
    }
}
