//
//  TripView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI

struct TripView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: TripViewModel
    
    init(trip: Trip) {
        self.init(openState: .details(trip))
    }
    
    init(openState: TripOpenState) {
        _viewModel = StateObject(wrappedValue: TripViewModel(openState: openState))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isCurrentUserParticipantOfTrip {
                tabBarView
                    .fullScreenCover(item: $viewModel.tripToEdit) { trip in
                        ManageTripView(mode: .edit(trip: trip)) { updatedTrip in
                            viewModel.updateTrip(with: updatedTrip)
                        }
                    }
            } else {
                VStack(spacing: 0) {
                    tripDetailsView
                    
                    joinView
                }
            }
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .sheet(isPresented: $viewModel.isApplicationLetterFormShown) {
            TripApplicationForm { message in
                viewModel.joinRequestSend(message: message)
            }
            .presentationDragIndicator(.visible)
            .handle(loading: $viewModel.loadingState)
            .handle(error: $viewModel.error)
        }
        .animation(.default, value: viewModel.nonParticipantTripRequest)
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)

    }
    
}

extension TripView {
    
    @ViewBuilder
    private var joinView: some View {
        if let request = viewModel.nonParticipantTripRequest {
            switch request.status {
            case .inviteRejected:
                inviteRejectedView

            case .invitePending:
                invitePendingView(request: request)
                
            case .requestPending:
                requestPendingView(request: request)

            case .requestRejected:
                requestRejectedView
                
            case .inviteAccepted, .requestApproved:
                EmptyView()
                
            case .requestCancelled:
                joinButtonView
            }
            
        } else {
            joinButtonView
        }
    }
    
    private var joinButtonView: some View {
        Button(String.Trip.requestToJoin) {
            viewModel.joinButtonAction()
        }
        .buttonStyle(WideBlueButtonStyle())
        .padding(.top, 12)
        .padding(.horizontal, 20)
    }
    
    private func requestPendingView(request: TripRequest) -> some View {
        HStack {
Spacer()
            VStack {
                Text(String.Trip.requestToJoinPending)
                    .foregroundColor(.Main.TLStrongBlack)
                    .font(.avenirBody)
                    .bold()
                
                Button {
                    viewModel.cancelJoinRequest(request)
                } label: {
                    Text(String.Main.cancel)
                        .font(.avenirBody)
                        .foregroundColor(.Main.TLStrongBlack)
                        .underline()
                }
            }
            .padding(.top, 12)
            Spacer()
        }
        .background {
            Color.Main.yellow
                .ignoresSafeArea()

        }

    }
    
    private func invitePendingView(request: TripRequest) -> some View {
        HStack {
                Spacer()
            VStack {
                Text(String.Trip.inviteToJoinPending)
                    .foregroundColor(.Main.TLStrongBlack)
                    .font(.avenirBody)
                    .bold()
                
                HStack {
                    Button {
                        viewModel.acceptInvite(request)
                    } label: {
                        Text(String.Main.accept)
                            .font(.avenirBody)
                            .foregroundColor(.Main.TLStrongBlack)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background {
                                Capsule()
                                    .fill(Color.Main.green.opacity(0.7))
                            }
                    }
                    
                    Button {
                        viewModel.rejectInvite(request)
                    } label: {
                        Text(String.Main.reject)
                            .font(.avenirBody)
                            .foregroundColor(.Main.TLStrongBlack)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background {
                                Capsule()
                                    .fill(Color.Main.accentRed.opacity(0.7))
                            }
                    }

                }
            }
            .padding(.top, 12)

            Spacer()

        }
        .background {
            Color.Main.yellow
                .ignoresSafeArea()

        }

    }
    
    private var requestRejectedView: some View {
        HStack {

            Spacer()
            
            VStack {
                Text(String.Trip.requestToJoinRejected)
                    .foregroundColor(.Main.TLStrongBlack)
                    .font(.avenirBody)
                    .bold()
                
                Button {
                    viewModel.joinButtonAction()
                } label: {
                    Text(String.Trip.requestToJoinAgain)
                        .foregroundColor(.Main.TLStrongBlack)
                        .font(.avenirBody)
                        .underline()
                }
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .background {
            Color.Main.accentRed
                .ignoresSafeArea()

        }
    }
    
    private var inviteRejectedView: some View {
        HStack {

            Spacer()
            
            VStack {
                Text(String.Trip.inviteToJoinRejected)
                    .foregroundColor(.Main.TLStrongBlack)
                    .font(.avenirBody)
                    .bold()
                
                Button {
                    viewModel.joinButtonAction()
                } label: {
                    Text(String.Trip.requestToJoinAgain)
                        .foregroundColor(.Main.TLStrongBlack)
                        .font(.avenirBody)
                        .underline()
                }
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .background {
            Color.Main.accentRed
                .ignoresSafeArea()

        }
    }

    
    private var tripDetailsView: some View {
        TripDetailsView(trip: viewModel.trip, isMembersManagmentOpen: viewModel.isMembersManagmentOpen) {
            viewModel.editTrip()
        }
    }
    
    private var tabBarView: some View {
        TabView(selection: $viewModel.selectedTab) {
            tripDetailsView
                .tabItem {
                    Label(String.Trip.detailsTitle, systemImage: "flag.fill")
                }.tag(TripViewModel.TabSelection.details)
                .tint(Color.Main.black)
            
            TripChatView(title: viewModel.trip.name, chat: viewModel.trip.chat, selected: viewModel.selectedTab == .chats)
                .tabItem {
                    Label(String.Trip.discussionTitle, systemImage: "text.bubble.fill")
                }.tag(TripViewModel.TabSelection.chats)
                .badge(viewModel.chatBadgeCount)
                .tint(Color.Main.black)
        }
        .tint(.Main.accentBlue)
    }
            
    private var getLocationName: String {
        viewModel.trip.location.nameAndFlag
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(openState: .details(.testOngoing))
    }
}
