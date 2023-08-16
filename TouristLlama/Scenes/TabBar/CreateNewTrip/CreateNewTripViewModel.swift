//
//  CreateNewTripViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import SwiftUI
import Dependencies

@MainActor
class CreateNewTripViewModel: ViewModel {
    
    @Dependency(\.tripsAPI) var tripsAPI
    
    enum TripCreationError: LocalizedError {
        case noName
//        case noStyle
        case noLocation
        case noStartDate
        case noEndDate
        case noDescription
        case noPhoto
        
        var errorDescription: String? {
            switch self {
            case .noName: return String.MyTrips.createErrorNoName
//            case .noStyle: return String.MyTrips.createErrorNoStyle
            case .noLocation: return String.MyTrips.createErrorNoLocation
            case .noStartDate: return String.MyTrips.createErrorNoStartDate
            case .noEndDate: return String.MyTrips.createErrorNoEndDate
            case .noDescription: return String.MyTrips.createErrorNoDescription
            case .noPhoto: return String.MyTrips.createErrorNoPhoto
            }
        }
    }
        
    @Published var currentCreationStage: TripCreationStage = .generalInfo {
        willSet {
            previousCreationStage = currentCreationStage
        }
    }
    var previousCreationStage: TripCreationStage = .generalInfo
    @Published var finishedCreationStages: Set<TripCreationStage> = [.generalInfo]
    @Published var tripName: String = ""
    @Published var tripStyle: TripStyle?
    @Published var tripLocation: TripLocation?
    @Published var tripStartDate: Date?
    @Published var tripEndDate: Date?
    @Published var tripDescription: String = ""
    @Published var tripPhoto: TripPhoto?
    @Published var isTripPublic: Bool = true
    @Published var shouldDismiss: Bool = false

        
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
        guard !tripName.isEmpty else {
            currentCreationStage = .generalInfo
            self.error = TripCreationError.noName
            return
        }
//        guard tripStyle != .none else {
//            currentCreationStage = .generalInfo
//            self.error = TripCreationError.noStyle
//            return
//        }
        guard let tripLocation else {
            currentCreationStage = .generalInfo
            self.error = TripCreationError.noLocation
            return
        }
        guard let tripStartDate else {
            currentCreationStage = .generalInfo
            self.error = TripCreationError.noStartDate
            return
        }
        guard let tripEndDate else {
            currentCreationStage = .generalInfo
            self.error = TripCreationError.noEndDate
            return
        }
        guard !tripDescription.isEmpty else {
            currentCreationStage = .description
            self.error = TripCreationError.noDescription
            return
        }

        guard let tripPhoto else {
            currentCreationStage = .photo
            self.error = TripCreationError.noPhoto
            return
        }

        let trip = Trip(id: "",
                        name: tripName,
                        style: tripStyle,
                        location: tripLocation,
                        startDate: tripStartDate,
                        endDate: tripEndDate,
                        description: tripDescription,
                        photo: tripPhoto,
                        isPublic: isTripPublic,
                        participants: [],
                        ownerId: "")
        Task {
            do {
                try await tripsAPI.create(trip: trip)
                self.shouldDismiss = true
            } catch {
                self.error = error
            }
        }
    }
    
    var isButtonDisabled: Bool {
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
    
    var buttonText: String {
        return currentCreationStage == .settings ? String.Main.create : String.Main.continue
    }
}
