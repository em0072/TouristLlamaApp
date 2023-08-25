//
//  MyTripsViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import Dependencies

class MyTripsViewModel: ViewModel {
    
    @Dependency(\.tripsAPI) var tripsAPI
    @Dependency(\.userAPI) var userAPI

    enum ViewDataMode {
        case ongoing
        case past
    }
        
    @Published var isShowingNewTripCreation = false
    @Published var myOngoingTrips: [Trip] = []
    @Published var myFutureTrips: [Trip] = []
    @Published var myPastTrips: [Trip] = []
    @Published var selectedTrip: Trip?
    
    @Published var viewDataMode: ViewDataMode = .ongoing
    
    var totalTripsCount: Int {
        myFutureTrips.count + myOngoingTrips.count + myPastTrips.count
    }
    
    func startCreationOfNewTrip() {
        isShowingNewTripCreation = true
    }

    func openDetails(for trip: Trip) {
        selectedTrip = trip
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        
        subscribeToMyTripsUpdates()
        
//        subscribeToUserUpdates()
    }
    
    private func subscribeToMyTripsUpdates() {
        tripsAPI.$myTrips
            .receive(on: DispatchQueue.main)
            .sink { [weak self] myTrips in
                guard let self else { return }
                self.clearTripsData()
                self.sortTrips(myTrips)
                if self.tripsAPI.myTripsIsLoaded {
                    self.state = .content
                }
            }
            .store(in: &publishers)
    }
    
//    private func subscribeToUserUpdates() {
//        userAPI.$currentUser
//            .receive(on: RunLoop.main)
//            .sink { [weak self] currentUser in
//                if currentUser == nil {
//                    self?.selectedTrip = nil
//                }
//            }
//            .store(in: &publishers)
//    }

    
    private func clearTripsData() {
        myFutureTrips.removeAll()
        myOngoingTrips.removeAll()
        myPastTrips.removeAll()
    }
    
    private func sortTrips(_ allTrips: [Trip]) {
        for trip in allTrips {
            if trip.startDate > Date().removeTimeStamp {
                myFutureTrips.append(trip)
            } else if trip.endDate >= Date().removeTimeStamp {
                myOngoingTrips.append(trip)
            } else {
                myPastTrips.append(trip)
            }
        }
    }
        
//    private func getMyTrips() async {
//            do {
//                let myTrips = try await tripsAPI.getMyTrips()
//                myFutureTrips.removeAll()
//                myOngoingTrips.removeAll()
//                myPastTrips.removeAll()
//                for trip in myTrips {
//                    if trip.startDate > Date() {
//                        myFutureTrips.append(trip)
//                    } else if trip.endDate > Date() {
//                        myOngoingTrips.append(trip)
//                    } else {
//                        myPastTrips.append(trip)
//                    }
//                }
//                self.state = .content
//            } catch {
//                self.error = error
//            }
//    }
    
//    @Sendable
//    func updateData() async {
//        switch viewDataMode {
//        case .ongoing:
//            await getMyTrips()
//
//        case .past:
//            return
//        }
//    }
    
//    func updateMyTrips() {
//        Task {
//            await getMyTrips()
//        }
//    }
}
