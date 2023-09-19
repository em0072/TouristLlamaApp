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
    
    @Dependency(\.tripsAPI) var tripsAPI
    @Dependency(\.userAPI) var userAPI
    @Dependency(\.chatAPI) var chatAPI
    @Dependency(\.userDefaultsController) var userDefaultsController
    @Dependency(\.tripsController) var tripsController

//    enum ViewDataMode {
//        case ongoing
//        case past
//    }
        
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
        
//    @Published var viewDataMode: ViewDataMode = .ongoing
    
    var totalTripsCount: Int {
        myFutureTrips.count + myOngoingTrips.count + myPastTrips.count
    }
    
    func startCreationOfNewTrip() {
        isShowingNewTripCreation = true
    }

    func openDetails(for trip: Trip) {
//        tripOpenState = .details(trip)
        tripsController.open(tripOpenState: .details(trip))
    }
    
    func openMembersManage(for trip: Trip) {
//        tripOpenState = .members(trip)
        tripsController.open(tripOpenState: .members(trip))
    }
    
    func openChat(for trip: Trip) {
//        tripOpenState = .chat(trip)
        tripsController.open(tripOpenState: .chat(trip))

    }
    
    func tripCellIcons(_ trip: Trip) -> [MyTripsCellView.Icon] {
        var icons = [MyTripsCellView.Icon]()
        if trip.requestsPendingCount > 0 {
            icons.append(.requests)
        }
        if let lastMessage = trip.lastMessage, lastMessage.id != userDefaultsController.getLastMessageId(for: trip.id) {
            icons.append(.chat)
        }
        return icons
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        
        subscribeToMyTripsUpdates()
    }
    
//    func updateMyTrips() {
//        myTrips = tripsAPI.myTrips
//    }
    
    private func subscribeToMyTripsUpdates() {
        tripsController.$myTrips
            .receive(on: RunLoop.main)
            .sink { [weak self] myTrips in
                guard let self, let myTrips else { return }
                self.myTrips = myTrips
//                if self.tripsAPI.myTripsIsLoaded {
                    self.state = .content
//                    self.subscribeToChatUpdates()
//                }
                
            }
            .store(in: &publishers)
    }
    
//    private func subscribeToChatUpdates() {
//        chatPublishers.removeAll()
//        for trip in myTrips {
//            guard let chatId = trip.lastMessage?.chatId else { continue }
//            chatAPI.subscribeToChatUpdates(for: chatId)
//                .receive(on: RunLoop.main)
//                .sink { [weak self] message in
//                    guard let self else { return }
////                    self.tripsController
////                    tripsAPI.updateLastMessage(tripId: trip.id, message: message)
////                    let tripChatId = trip.lastMessage?.chatId
////                    let messageChatId = message.chatId
////                    if tripChatId == messageChatId, let tripIndex = myTrips.firstIndex(where: { $0.id == trip.id }) {
////                        myTrips[tripIndex].lastMessage = message
////                    }
//                }
//                .store(in: &chatPublishers)
//        }
//    }
    
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
