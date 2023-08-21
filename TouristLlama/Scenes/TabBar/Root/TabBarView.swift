//
//  TabBarView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 09/08/2023.
//

import SwiftUI

struct TabBarView: View {
    
    enum TabOption {
        case myTrips
        case profile
    }
    
    @StateObject var viewModel = TabBarViewModel()
    
    var body: some View {
        TabView {
            MyTripsView()
                .tabItem {
                    Label {
                        Text("My Trips")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .foregroundColor(.Main.accentBlue)
                }
                .tag(TabOption.myTrips)
                .tint(.Main.black)
            
            ProfileView()
            .tabItem {
                Label {
                    Text("Profile")
                        .font(.avenirBody)
                } icon: {
                    Image(systemName: "person.circle.fill")
                }
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
