//
//  MyTripsViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import Foundation
import Dependencies
import Combine

class MyTripsViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.chatAPI) var chatAPI
    @Dependency(\.userDefaultsController) var userDefaultsController
    @Dependency(\.tripsController) var tripsController
    
    @Published var isShowingNewTripCreation = false
    @Published var myTrips: [Trip] = [] {
        didSet {
            sortTrips()
        }
    }
    @Published var myOngoingTrips: [Trip] = []
    @Published var myFutureTrips: [Trip] = []
    @Published var myPastTrips: [Trip] = []
    @Published var tripOpenState: TripOpenState?
    @Published var chatPublishers = [AnyCancellable]()
        
    var totalTripsCount: Int {
        myFutureTrips.count + myOngoingTrips.count + myPastTrips.count
    }
    
    func startCreationOfNewTrip() {
        isShowingNewTripCreation = true
    }
    
    func openDetails(for trip: Trip) {
        tripsController.open(tripOpenState: .details(trip))
    }
    
    func openMembersManage(for trip: Trip) {
        tripsController.open(tripOpenState: .members(trip))
    }
    
    func openChat(for trip: Trip) {
        tripsController.open(tripOpenState: .chat(trip))
        
    }
    
    func tripCellIcons(_ trip: Trip) -> [MyTripsCellView.Icon] {
        var icons = [MyTripsCellView.Icon]()
        if trip.requestsPendingCount > 0 {
            icons.append(.requests)
        }
        if let lastMessage = trip.lastMessage,
           lastMessage.id != userDefaultsController.getLastMessageId(for: trip.id) && lastMessage.ownerId != userAPI.currentUser?.id {
            icons.append(.chat)
        }
        return icons
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        
        subscribeToMyTripsUpdates()
    }
    
    private func subscribeToMyTripsUpdates() {
        tripsController.$myTrips
            .receive(on: RunLoop.main)
            .sink { [weak self] myTrips in
                guard let self, let myTrips else { return }
                self.myTrips = myTrips
                self.state = .content
            }
            .store(in: &publishers)
    }
    
    private func clearTripsData() {
        myFutureTrips.removeAll()
        myOngoingTrips.removeAll()
        myPastTrips.removeAll()
    }
    
    private func sortTrips() {
        clearTripsData()
        for trip in myTrips {
            if trip.startDate > Date().removeTimeStamp {
                myFutureTrips.append(trip)
            } else if trip.endDate >= Date().removeTimeStamp {
                myOngoingTrips.append(trip)
            } else {
                myPastTrips.append(trip)
            }
        }
        myFutureTrips.sort(by: { $0.startDate < $1.startDate })
        myOngoingTrips.sort(by: { $0.startDate < $1.startDate })
        myPastTrips.sort(by: { $0.startDate < $1.startDate })
    }
    
}
