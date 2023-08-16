//
//  TripView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI

struct TripView: View {
    
    enum TabSelection {
        case details
        case chats
    }
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: TripViewModel
    
    @State var selectedTab: TabSelection = .details
    
    init(trip: Trip) {
        _viewModel = StateObject(wrappedValue: TripViewModel(trip: trip))
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                TripDetailsView(viewModel: viewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "flag.fill")
                            Text(String.Trip.detailsTitle)
                        }
                    }.tag(TabSelection.details)
                
                TripChatsListView(viewModel: viewModel)
                    .tabItem {
                        VStack {
                            Image(systemName: "text.bubble.fill")
                            Text(String.Trip.discussionTitle)
                        }
                    }.tag(TabSelection.chats)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(selectedTab == .details ? "" : viewModel.trip.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    switch selectedTab {
                    case .details:
                        HStack(spacing: 8) {
                            editButton
                            shareButton
                        }
                    case .chats:
                        newDiscussionButton
                    }
                }
            }
            //            .manageSubscriptions(for: viewModel)
        }
        //        .accentColor(.TLBlack)
    }
    
}

extension TripView {
    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, Color.Main.white)
        }
    }
    
    private var shareButton: some View {
        Button {
            
        } label: {
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, Color.Main.white)
        }
    }
    
    private var editButton: some View {
        Button {
            
        } label: {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, Color.Main.white)
        }
    }
    
    private var moreButton: some View {
        Button {
            
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, Color.Main.white)
        }
    }
    
    private var newDiscussionButton: some View {
        Button {
            
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, Color.Main.white)
        }
    }
    
    
    private var getLocationName: String {
        viewModel.trip.location.nameAndFlag
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: Trip.testOngoing)
    }
}
