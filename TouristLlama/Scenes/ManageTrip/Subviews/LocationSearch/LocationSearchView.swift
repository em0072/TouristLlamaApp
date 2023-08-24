//
//  LocationSearchView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 10/08/2023.
//

import SwiftUI

struct LocationSearchView: View {
    
    @StateObject private var viewModel = LocationSearchViewModel()
    
    var onSelect: ((LocationSearchViewData) -> ())? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                searchTextFieldView
                
                FieldTitleView(title: String.Trips.createTripLocationSearchResultsTitle + ":")
                
                resultsView
            }
            .padding(.horizontal, 20)
            .navigationTitle(String.Trips.createTripLocationSearchTitle)
        }
        .onChange(of: viewModel.selectedItem) { selectedItem in
            guard let selectedItem else { return }
            onSelect?(selectedItem)
        }
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
    }
    
    func onListItemSelect(item: LocationCompletionViewData) {
        viewModel.requestMapItem(with: item.completion) { result in
            switch result {
            case .success(let mapItem):
                self.onSelect?(mapItem)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension LocationSearchView {
    
    private var searchTextFieldView: some View {
        FramedTextField(title: "",
                        prompt: String.Trips.createTripLocationSearchPrompt,
                        value: $viewModel.searchText,
                        styles: [.withDeleteButton, .withLoading(viewModel.isShowingActivityIndicator)])
    }
    
    @ViewBuilder
    private var resultsView: some View {
        if viewModel.viewData.isEmpty {
            VStack {
                Spacer()
                if viewModel.isShowingActivityIndicator {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    IconPlaceholderView(icon: resultsPlaceholderIcon,
                                        text: resultsPlaceholderText)
                }
                Spacer()
            }
        } else {
            ScrollView {
                ForEach(viewModel.viewData) { item in
                    resultCell(for: item)
                }
            }
        }
    }
    
    private func resultCell(for viewDataItem: LocationCompletionViewData) -> some View {
        Button {
            viewModel.onListItemSelect(item: viewDataItem.completion)
        } label: {
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: "location.fill")
                    
                    VStack(alignment: .leading) {
                        Text(viewDataItem.attributedTitle)
                        Text(viewDataItem.attributedSubtitle)
                            .opacity(0.7)
                    }
                    Spacer()
                }
                Divider()
                    .padding(.leading, 25)
            }
        }
    }
    
    private var resultsPlaceholderIcon: String {
        viewModel.searchText.isEmpty ? "location.magnifyingglass" : ""
    }
    
    private var resultsPlaceholderText: String {
        viewModel.searchText.isEmpty ? String.Trips.createTripLocationSearchResultsPrompt : String.Main.noResults
    }


}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
