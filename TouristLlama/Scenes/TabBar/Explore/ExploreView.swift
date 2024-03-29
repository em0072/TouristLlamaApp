//
//  ExploreView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 23/08/2023.
//

import SwiftUI
import AspirinShot

struct ExploreView: View {
    
    @StateObject var viewModel: ExploreViewModel = .init()
    
    var body: some View {
        ZStack {
            
            switch viewModel.state {
            case .loading:
                LoadingView()
                
            case .content:
                let _ = print("content Rendered", Date().timeIntervalSince1970)
                contentView
            }
            
            VStack {
                searchFieldView
                filtersTitle
                Spacer()
            }

        }
        .background {
            Color.Main.white
                .ignoresSafeArea()
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
        VStack {
            FramedTextField(title: nil,
                            prompt: String.Trips.searchPrompt,
                            value: $viewModel.searchPrompt,
                            styles: [.withLeftIcon("magnifyingglass"),
                                     .withLoading(viewModel.isSearching && !viewModel.searchPrompt.isEmpty),
                                     .withDeleteButton,
                                     .withRightButton(icon: "slider.horizontal.3", action: {
                                         viewModel.openFilters()
                                     }),
                                     .backgroundColor(.Main.white.opacity(0.4)),
                                     .withShadow(.inner(color: .black.opacity(0.5), radius: 1, x: 0, y: 0))
                            ])
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .background {
                Rectangle()
                    .fill(.thinMaterial)
                    .ignoresSafeArea()
            }
            
//            Spacer()
        }
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
                    if viewModel.filtersTitle != nil {
                        Spacer()
                            .frame(height: 50)
                    }
                    ForEach(viewModel.trips) { trip in
                        tripCell(for: trip)
                    }
                }
                .padding(.horizontal, 20)
            }
            .safeAreaInset(edge: .top) {
                Spacer()
                    .frame(height: 70)
            }
    }
    
    @ViewBuilder
    private var filtersTitle: some View {
        if let title = viewModel.filtersTitle {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.avenirBody)
                        .foregroundColor(.primary)
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
                        .fill(.thinMaterial)
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
    static var viewModel: ExploreViewModel {
        let viewModel = ExploreViewModel()
        viewModel.filters.tripStyle = .active
        return viewModel
    }
    
    static var previews: some View {
        NavigationStack {
            ExploreView(viewModel: ExploreView_Previews.viewModel)
        }
    }
}
