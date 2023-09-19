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
        self.init(openState: .details(trip))
    }
    
    init(openState: TripOpenState) {
        _viewModel = StateObject(wrappedValue: TripViewModel(openState: openState))
    }
        
    var body: some View {
        ZStack {
            if viewModel.isCurrentUserParticipantOfTrip {
                tabBarView
                    .fullScreenCover(item: $viewModel.tripToEdit) { trip in
                        ManageTripView(mode: .edit(trip: trip)) { updatedTrip in
                            viewModel.updateTrip(with: updatedTrip)
                        }
                    }
            } else {
                tripDetailsView
            }
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
        
    }
    
}

extension TripView {
    
    private var tripDetailsView: some View {
        TripDetailsView(viewModel: viewModel.tripDetailViewModel) {
            viewModel.editTrip()
        }
    }
    
    
    private var tabBarView: some View {
        TabView(selection: $viewModel.selectedTab) {
            tripDetailsView
                .tabItem {
                    Label(String.Trip.detailsTitle, systemImage: "flag.fill")
                }.tag(TripViewModel.TabSelection.details)
                .tint(Color.Main.black)
            
            TripChatView(title: viewModel.trip.name, viewModel: viewModel.tripChatViewModel)
                .tabItem {
                    Label(String.Trip.discussionTitle, systemImage: "text.bubble.fill")
                }.tag(TripViewModel.TabSelection.chats)
                .badge(viewModel.chatBadgeCount)
                .tint(Color.Main.black)
        }
        .tint(.Main.accentBlue)
    }
    
    private var getLocationName: String {
        viewModel.trip.location.nameAndFlag
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(openState: .details(.testAmsterdam))
    }
}
