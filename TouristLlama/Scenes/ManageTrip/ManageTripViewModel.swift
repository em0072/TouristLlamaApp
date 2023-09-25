//
//  ManageTripViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import SwiftUI
import Dependencies

@MainActor
class ManageTripViewModel: ViewModel {
    
    @Dependency(\.tripsAPI) var tripsAPI
    
    enum Mode {
        case create
        case edit(trip: Trip)
    }
    
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
            case .noName: return String.Trips.createErrorNoName
//            case .noStyle: return String.MyTrips.createErrorNoStyle
            case .noLocation: return String.Trips.createErrorNoLocation
            case .noStartDate: return String.Trips.createErrorNoStartDate
            case .noEndDate: return String.Trips.createErrorNoEndDate
            case .noDescription: return String.Trips.createErrorNoDescription
            case .noPhoto: return String.Trips.createErrorNoPhoto
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
    @Published var isRequestInProgress: Bool = false

    let mode: Mode
    let onSubmit: ((Trip) -> Void)?
        
    init(mode: Mode, onSubmit: ((Trip) -> Void)?) {
        self.mode = mode
        self.onSubmit = onSubmit
        super.init()
        updateFieldsForEditIfNeeded()
    }
    
    private func updateFieldsForEditIfNeeded() {
        if case .edit(let trip) = mode {
            tripName = trip.name
            tripStyle = trip.style
            tripLocation = trip.location
            tripStartDate = trip.startDate
            tripEndDate = trip.endDate
            
            finishedCreationStages.insert(.description)
            tripDescription = trip.description
            
            finishedCreationStages.insert(.photo)
            tripPhoto = trip.photo
            
            finishedCreationStages.insert(.settings)
            isTripPublic = trip.isPublic
        }
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
            createOrUpdateTrip()
        }
        finishedCreationStages.insert(currentCreationStage)

    }
    
//    func prepareForScreenshot(isInScreenshot: Bool) {
//#if DEBUG
//        if isInScreenshot {
//            tripName = Trip.testParis.name
//            tripStyle = Trip.testParis.style
//        }
//#endif
//    }
    
    private func areAllFieldsCompleted() -> Bool {
        
        
        return true
    }
    
    private func createOrUpdateTrip() {
        guard !tripName.isEmpty else {
            currentCreationStage = .generalInfo
            self.error = TripCreationError.noName
            return
        }
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
        isRequestInProgress = true

        switch mode {
        case .create:
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
            create(trip: trip)
            
        case .edit(let tripToUpdate):
            let trip = Trip(id: tripToUpdate.id,
                            name: tripName,
                            style: tripStyle,
                            location: tripLocation,
                            startDate: tripStartDate,
                            endDate: tripEndDate,
                            description: tripDescription,
                            photo: tripPhoto,
                            isPublic: isTripPublic,
                            participants: tripToUpdate.participants,
                            ownerId: tripToUpdate.ownerId)
            update(trip: trip)
        }
    }
    
    private func create(trip: Trip) {
        Task {
            do {
                try await tripsAPI.create(trip: trip)
                self.onSubmit?(trip)
                self.shouldDismiss = true
            } catch {
                self.error = error
                self.isRequestInProgress = false
            }
        }
    }
    
    private func update(trip: Trip) {
        Task {
            do {
                let updatedTrip = try await tripsAPI.edit(trip: trip)
                self.onSubmit?(updatedTrip)
                self.shouldDismiss = true
            } catch {
                self.error = error
                self.isRequestInProgress = false
            }
        }
    }
    
    var isButtonDisabled: Bool {
        guard !isRequestInProgress else { return true }
        switch currentCreationStage {
        case .generalInfo:
            return tripName.isEmpty || tripLocation == nil || tripStartDate == nil || tripEndDate == nil
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
        if currentCreationStage == .settings {
            switch mode {
            case .create:
                return String.Main.create
                
            case .edit:
                return String.Main.update
            }
        } else {
            return String.Main.continue
        }
    }
    
    var navigationTitle: String {
        switch mode {
        case .create:
            return String.Trips.createTripTitle
            
        case .edit:
            return String.Trips.editTripTitle
        }
    }
}
