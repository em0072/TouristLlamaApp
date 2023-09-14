//
//  NotificationsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 08/09/2023.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .loading:
                    LoadingView()
                    
                case .content:
                    contentView
                }
            }
            .handle(loading: $viewModel.loadingState)
            .handle(error: $viewModel.error)
            .navigationTitle(String.Notifications.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    readAllButton
                }
            }
        }
    }
}

extension NotificationsView {
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.myNotifications.isEmpty {
            NoResultsView()
        } else {
            listView
        }
    }
    
    private var listView: some View {
        List(viewModel.myNotifications) { notification in
            NotificationCellView(notification: notification)
                .onTapGesture {
                    viewModel.openTrip(tripId: notification.tripId)
                }
                .listRowBackground(Color.Main.listItem)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    
                    Button {
                        viewModel.markNotificationAsRead(id: notification.id)
                    } label: {
                        Image(systemName: "eye")

                    }
                    .tint(Color.Main.accentBlue)
                    
                    Button(role: .destructive) {
                        viewModel.deleteNotification(id: notification.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(Color.red)

                }
        }
        .background(Color.Main.white)
        .scrollContentBackground(.hidden)
    }
    
    private var readAllButton: some View {
        Button {
            viewModel.markAllNotificationAsRead()
        } label: {
            Text(String.Notifications.markAllAsRead)
                .font(.avenirBody)
        }

    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
