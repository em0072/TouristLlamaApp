//
//  SearchingUsersView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 30/08/2023.
//

import SwiftUI
import Kingfisher

struct SearchingUsersView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: SearchingUsersViewModel
    
    @Binding var loadingState: LoadingState
    private let isDisabled: (User) -> Bool
    private let onUserSelection: (User) -> Void
    
    init(loadingState: Binding<LoadingState>, isDisabled: @escaping (User) -> Bool, onUserSelection: @escaping (User) -> Void) {
        _viewModel = StateObject(wrappedValue: SearchingUsersViewModel())
        self._loadingState = Binding(projectedValue: loadingState)
        self.isDisabled = isDisabled
        self.onUserSelection = onUserSelection
    }

    var body: some View {
        VStack {
            searchFieldView
                .padding(.horizontal, 20)
                .padding(.vertical, 12)

            switch viewModel.state {
            case .content:
                if viewModel.searchPrompt.isEmpty {
                    initalView
                        .padding(.horizontal, 20)
                } else if viewModel.users.isEmpty {
                    emptyView
                        .padding(.horizontal, 20)
                } else {
                    contentView
                }
                
            case .loading:
                loadingView
            }
        }
        .sheet(item: $viewModel.selectedUser) { user in
            ProfileView(user: user)
                .presentationDragIndicator(.visible)
        }
        .handle(loading: $loadingState)
        .handle(error: $viewModel.error)
    }
}

extension SearchingUsersView {
    
    private var searchFieldView: some View {
        FramedTextField(title: nil,
                        prompt: String.Main.search,
                        value: $viewModel.searchPrompt,
                        styles: [.withLeftIcon("magnifyingglass"),
                                 .withLoading(viewModel.state == .loading && !viewModel.searchPrompt.isEmpty),
                                 .withDeleteButton
                        ])
    }

    
    private var initalView: some View {
        VStack{
            Spacer()
            IconPlaceholderView(icon: "text.cursor", text: String.Trip.userSearchInitialInstruction)
            Spacer()
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Search Result")
                .font(.avenirBigBody)
                .bold()
                .foregroundColor(.Main.black)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack {
                    ForEach(viewModel.users) { user in
                        cellView(for: user)
                            .onTapGesture {
                                viewModel.cellTapAction(for: user)
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func cellView(for user: User) -> some View {
        SearchingUsersListCell(user: user) {
            onUserSelection(user)
        }
        .disabled(isDisabled(user))
    }
    
    private var emptyView: some View {
        VStack{
            Spacer()
            IconPlaceholderView(icon: "location.magnifyingglass", text: String.Main.noResults)
            Spacer()
        }
    }
    
    private var loadingView: some View {
        VStack{
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct SearchingUsersView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingUsersView(loadingState: .constant(.loading)) { _ in
            return .random()
        } onUserSelection: { _ in
            
        }
    }
}
