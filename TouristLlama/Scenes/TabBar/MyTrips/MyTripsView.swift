//
//  MyTripsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct MyTripsView: View {
    
    @StateObject var viewModel = MyTripsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .content:
                    contentView
                                        
                case .loading:
                    loadingView
                }
            }
            .navigationTitle(String.Trips.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String.Trips.createTripButton) {
                        viewModel.startCreationOfNewTrip()
                    }
                    .buttonStyle(CapsuleBlueButtonStyle())
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingNewTripCreation) {
            ManageTripView(mode: .create)
            .interactiveDismissDisabled()
        }
        .fullScreenCover(item: $viewModel.tripOpenState) { tripState in
            TripView(openState: tripState)
        }
        .handle(error: $viewModel.error)
    }
}

extension MyTripsView {
    
    private var contentView: some View {
        ZStack {
            emptyView
            
            ScrollView {
                VStack(spacing: 12) {
                    scrollViewSection(title: .Trips.ongoingSectionTitle,
                                      trips: viewModel.myOngoingTrips,
                                      isHighlighted: true)
                    
                    scrollViewSection(title: .Trips.futureSectionTitle,
                                      trips: viewModel.myFutureTrips)

                    scrollViewSection(title: .Trips.pastSectionTitle,
                                      trips: viewModel.myPastTrips,
                                      isDimmed: true)
                }
                .padding(20)
            }
        }
    }
    
    @ViewBuilder
    private func scrollViewSection(title: String, trips: [Trip], isHighlighted: Bool = false, isDimmed: Bool = false) -> some View {
        if !trips.isEmpty {
            Section {
                ForEach(trips) { trip in
                    Button {
                        viewModel.openDetails(for: trip)
                    } label: {
                        MyTripsCellView(trip: trip,
                                        icons: viewModel.tripCellIcons(trip),
                                        isHighlighted: isHighlighted) {
                            viewModel.openMembersManage(for: trip)
                        } onChatOpen: {
                            viewModel.openChat(for: trip)
                        }
                            .opacity(isDimmed ? 0.5 : 1)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                FieldTitleView(title: title)
            }
        }
    }

        @ViewBuilder
    private var emptyView: some View {
        if viewModel.totalTripsCount == .zero {
                IconPlaceholderView(icon: "paperplane", text: "No trips planned")
        }
    }
    
    private var errorView: some View {
        IconPlaceholderView(icon: "xmark.circle.fill", text: viewModel.error?.localizedDescription ?? "Something went wrong")
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            
            ProgressView()
                .progressViewStyle(.circular)
            
            Spacer()
        }
    }
}

struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}
