//
//  ExploreView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel: ExploreViewModel = .init()
    
    var body: some View {
        VStack {
            searchFieldView
                .padding(.horizontal, 20)
            
            switch viewModel.state {
            case .loading:
                LoadingView()
                
            case .content:
                contentView
            }
            
        }
        .onAppear {
            viewModel.requestTrips()
        }
        .fullScreenCover(item: $viewModel.tripToOpen) { trip in
            TripView(trip: trip)
        }
        .sheet(isPresented: $viewModel.areFiltersOpen) {
            TripsFiltersView(filters: viewModel.filters) { filters in
                viewModel.set(filters)
            }
        }
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
    }
}

extension ExploreView {
    
    private var searchFieldView: some View {
        FramedTextField(title: nil,
                        prompt: String.Trips.searchPrompt,
                        value: $viewModel.searchPrompt,
                        styles: [.withLeftIcon("magnifyingglass"),
                                 .withLoading(viewModel.isSearching && !viewModel.searchPrompt.isEmpty),
                                 .withDeleteButton,
                                 .withRightButton(icon: "slider.horizontal.3", action: {
                                     viewModel.openFilters()
                                 })
                        ])
    }
    
    @ViewBuilder
    private var contentView: some View {
        filtersTitle
        if viewModel.trips.isEmpty {
            NoResultsView()
        } else {
            listView
        }
    }
    
    private var listView: some View {
        VStack {            
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(viewModel.trips) { trip in
                        tripCell(for: trip)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    private var filtersTitle: some View {
        if let title = viewModel.filtersTitle {
            HStack(spacing: 8) {
                Text(title)
                    .font(.avenirBody)
                Button {
                    withAnimation {
                        viewModel.clearFilters()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }

            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
                .background {
                    Capsule()
                        .fill(Color.Main.TLInactiveGrey)
                }
                .padding(.top, 8)
        }
    }
    
    private func tripCell(for trip: Trip) -> some View {
        Button {
            viewModel.open(trip)
        } label: {
            ExploreListCellView(trip: trip, showBadge: viewModel.shouldShowNotificationBadge(trip))
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
