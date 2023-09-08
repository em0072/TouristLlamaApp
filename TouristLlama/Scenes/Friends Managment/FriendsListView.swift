//
//  FriendsListView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 05/09/2023.
//

import SwiftUI

struct FriendsListView: View {
    
    @StateObject private var viewModel = FriendsListViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                LoadingView()
                
            case .content:
                contentView
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                newFriendButton
            }
        }
        .sheet(isPresented: $viewModel.isSearchingForUsersShown) {
            SearchingUsersView(loadingState: $viewModel.loadingState, showUserFriends: false) { userToCheck in
                !viewModel.isUserCanBeAdded(userToCheck)
            } onUserSelection: { userToAdd in
                viewModel.addFriend(userToAdd)
            }
            .presentationDragIndicator(.visible)

        }
        .navigationTitle(String.Friends.myFriends)
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)

    }
}

extension FriendsListView {
        
    @ViewBuilder
    private var contentView: some View {
        if viewModel.userFriends.isEmpty {
            IconPlaceholderView(icon: "figure.wave.circle", text: String.Friends.noFriendsTitle)
        } else {
            List(viewModel.userFriends) { friend in
                
                    FriendsListCell(user: friend)
                    .listRowBackground(Color.Main.listItem)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.removeFriend(friend)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                        .padding(.vertical, 6)
                        .background {
                            NavigationLink {
                                ProfileView(user: friend)
                            } label: { EmptyView() }.opacity(0).buttonStyle(.plain)
                        }
            }
            .background(Color.Main.white)
            .scrollContentBackground(.hidden)
            
        }
    }
    
    private var newFriendButton: some View {
        Button {
            viewModel.addNewFriendButtonAction()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, .thinMaterial)
        }
    }

}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FriendsListView()
        }
    }
}
