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
    private let showUserFriends: Bool
    private let isDisabled: (User) -> Bool
    private let onUserSelection: (User) -> Void
    
    init(loadingState: Binding<LoadingState>, showUserFriends: Bool, isDisabled: @escaping (User) -> Bool, onUserSelection: @escaping (User) -> Void) {
        _viewModel = StateObject(wrappedValue: SearchingUsersViewModel())
        self._loadingState = Binding(projectedValue: loadingState)
        self.showUserFriends = showUserFriends
        self.isDisabled = isDisabled
        self.onUserSelection = onUserSelection
    }

    var body: some View {
        ZStack {

            switch viewModel.state {
            case .content:
                if viewModel.searchPrompt.isEmpty {
                    initalView
                } else if viewModel.users.isEmpty {
                    emptyView
                        .padding(.horizontal, 20)
                } else {
                    contentView
                }
                
            case .loading:
                LoadingView()
            }
            
            searchFieldView

        }
        .background(Color.Main.white)
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
        VStack {
        FramedTextField(title: nil,
                        prompt: String.Main.search,
                        value: $viewModel.searchPrompt,
                        styles: [.withLeftIcon("magnifyingglass"),
                                 .withLoading(viewModel.state == .loading && !viewModel.searchPrompt.isEmpty),
                                 .withDeleteButton,
                                 .backgroundColor(.Main.white.opacity(0.4)),
                                 .withShadow(.inner(color: .black.opacity(0.5), radius: 1, x: 0, y: 0))
                        ])
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        .padding(.top, 20)
        .background {
            Rectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
        }
        
        Spacer()
    }

    }

    
    private var initalView: some View {
        VStack(spacing: 6) {
            Spacer()
                .frame(height: 100)
            VStack {
                IconPlaceholderView(icon: "text.cursor", text: String.Trip.userSearchInitialInstruction)
                if showUserFriends {
                    Text(String.Main.or.lowercased())
                    Text(String.Friends.selectFromFriend.lowercased())
                }
            }
            .padding(.horizontal, 20)
            if showUserFriends {
                List(viewModel.friends) { friend in
                    cellView(for: friend)
                        .listRowBackground(Color.Main.listItem)
                        .onTapGesture {
                            viewModel.cellTapAction(for: friend)
                        }
                }
                .background(Color.Main.white)
                .scrollContentBackground(.hidden)
            }
            Spacer()
        }
        .font(.avenirBigBody)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            List {
                Section {
                    ForEach(viewModel.users) { user in
                        cellView(for: user)
                            .listRowBackground(Color.Main.listItem)
                            .onTapGesture {
                                viewModel.cellTapAction(for: user)
                            }
                    }
                } header: {
                    Text("Search Result")
                        .font(.avenirBody)
                        .bold()
                        .foregroundColor(.Main.black)
                }

            }
            .background(Color.Main.white)
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .top) {
                Spacer()
                    .frame(height: 80)
            }
        }
    }
    
    private func cellView(for user: User) -> some View {
        SearchingUsersListCell(user: user) {
            onUserSelection(user)
        }
        .disabled(isDisabled(user))
        .buttonStyle(.plain)
    }
    
    private var emptyView: some View {
        VStack{
            Spacer()
            IconPlaceholderView(icon: "location.magnifyingglass", text: String.Main.noResults)
            Spacer()
        }
    }
    
}

struct SearchingUsersView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingUsersView(loadingState: .constant(.loading), showUserFriends: true) { _ in
            return .random()
        } onUserSelection: { _ in
            
        }
    }
}
