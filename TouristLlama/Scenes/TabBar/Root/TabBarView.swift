//
//  TabBarView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct TabBarView: View {
        
    @StateObject var viewModel = TabBarViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ExploreView()
                .tabItem {
                    Label {
                        Text(String.Main.exploreTab)
                    } icon: {
                        Image(systemName: viewModel.exploreTabIcon)
                    }
                    .environment(\.symbolVariants, .none)
                }
                .tag(TabOption.explore)
                .tint(.Main.black)

            MyTripsView()
                .tabItem {
                    Label {
                        Text(String.Main.myTripsTab)
                    } icon: {
                        Image(systemName: viewModel.myTripsTabIcon)
                    }
                    .environment(\.symbolVariants, .none)
                }
                .tag(TabOption.myTrips)
                .tint(.Main.black)
            
            NotificationsView()
                .tabItem {
                    Label {
                        Text(String.Main.notificationsTab)
                    } icon: {
                        Image(systemName: viewModel.notificationsTabIcon)
                    }
                    .environment(\.symbolVariants, .none)
                }
                .tag(TabOption.notifications)
                .tint(.Main.black)
                .badge(viewModel.notificationsBadgeNumber)
            
            ProfileView()
            .tabItem {
                Label {
                    Text(String.Main.profileTab)
                        .font(.avenirBody)
                } icon: {
                    Image(systemName: viewModel.profileTabIcon)
                }
                .environment(\.symbolVariants, .none)
            }
            .tag(TabOption.profile)
            .tint(.Main.black)
        }
        .tint(.Main.accentBlue)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
