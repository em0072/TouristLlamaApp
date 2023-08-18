//
//  TripView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI

struct TripView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: TripViewModel
    
    
    init(trip: Trip) {
        _viewModel = StateObject(wrappedValue: TripViewModel(trip: trip))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isCurrentUserParticipantOfTrip {
                tabBarView
            } else {
                tripDetailsView
            }
        }
    }
    
}

extension TripView {
    
    private var tripDetailsView: some View {
        TripDetailsView(viewModel: viewModel)
    }
    
    private var tabBarView: some View {
        TabView(selection: $viewModel.selectedTab) {
            tripDetailsView
                .tabItem {
                    Label(String.Trip.detailsTitle, systemImage: "flag.fill")
                }.tag(TripViewModel.TabSelection.details)

            TripChatsListView(viewModel: viewModel)
                .tabItem {
                    Label(String.Trip.discussionTitle, systemImage: "text.bubble.fill")
                }.tag(TripViewModel.TabSelection.chats)
                .badge(viewModel.chatBadgeCount)
                .tint(nil)
        }
        .tint(.Main.accentBlue)
    }
            
    private var getLocationName: String {
        viewModel.trip.location.nameAndFlag
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: Trip.testOngoing)
    }
}
