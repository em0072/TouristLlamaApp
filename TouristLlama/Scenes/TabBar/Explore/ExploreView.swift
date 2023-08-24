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
    }
}

extension ExploreView {
    
    private var searchFieldView: some View {
        FramedTextField(title: nil,
                        prompt: String.Trips.searchPrompt,
                        value: $viewModel.searchPrompt,
                        styles: [.withLeftIcon("magnifyingglass"),
                                 .withLoading(viewModel.isSearching),
                                 .withDeleteButton,
                                 .withRightButton(icon: "slider.horizontal.3", action: {
                                     viewModel.openFilters()
                                 })
                        ])
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.trips.isEmpty {
            NoResultsView()
        } else {
            listView
        }
    }
    
    private var listView: some View {
        ScrollView {
            VStack(spacing: 18) {
                ForEach(viewModel.trips) { trip in
                    tripCell(for: trip)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func tripCell(for trip: Trip) -> some View {
        ExploreListCellView(trip: trip)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
