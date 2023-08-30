//
//  TripManageMembersView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 28/08/2023.
//

import SwiftUI

struct TripManageMemebersView: View {
    
    @StateObject private var viewModel: TripManageMembersViewModel

    init(trip: Trip) {
            _viewModel = StateObject(wrappedValue: TripManageMembersViewModel(trip: trip))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                requestsPendingSection
                
                teamMembersSection
                
                rejectedSection
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle(String.Trip.manageMembersTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                newInviteButton
            }
        }
        .sheet(item: $viewModel.selectedUser) { user in
            ProfileView(user: user)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.isInviteViewShown, content: {
            SearchingUsersView(loadingState: $viewModel.loadingState) { user in
                !viewModel.canInvite(user)
            } onUserSelection: { user in
                viewModel.invite(user)
            }
            .presentationDragIndicator(.visible)
        })
        .confirmationDialog(String.Trip.manageRemoveUserDialogTitle, isPresented: $viewModel.isRemoveUserConfirmationShown, actions: {
            Button(String.Main.remove, role: .destructive) {
                viewModel.deleteAction()
            }
        }, message: {
            Text(String.Trip.manageRemoveUserDialogSubtitle)
                .font(.avenirBody)
        })
        .animation(.default, value: viewModel.trip)
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
    }
    
    private var newInviteButton: some View {
        
        Button {
            viewModel.inviteNewUserButtonAction()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, Color.Main.white)
        }
    }

    @ViewBuilder
    private var requestsPendingSection: some View {
        if !viewModel.shortListOfPendingRequests.isEmpty {
            Section {
                ForEach(viewModel.shortListOfPendingRequests) { request in
                    cell(for: request)
                }
                if viewModel.remainPendingRequestCount > 0 {
                    HStack {
                        Spacer()
                        Text(String.Trip.manageRequests(viewModel.remainPendingRequestCount))
                            .font(.avenirSmallBody)
                            .foregroundColor(.Main.grey)
                        Spacer()
                    }
                }
            } header: {
                HStack {
                    Text(String.Trip.manageRequestsSectionTitle)
                        .font(.avenirBody)
                        .bold()
                        .foregroundColor(.Main.black)
                    Spacer()
                }
            }
            .padding(.vertical, 12)
        }
    }

    
    private var teamMembersSection: some View {
        Section {
            ForEach(viewModel.participants) { participant in
                cell(for: participant)
            }
            ForEach(viewModel.invitationsPending) { invite in
                cell(for: invite)
            }
        } header: {
            HStack {
                Text(String.Trip.manageTeammatesSectionTitle)
                    .font(.avenirBigBody)
                    .bold()
                    .foregroundColor(.Main.black)
                Spacer()
            }
        }
        .padding(.vertical, 12)

    }
    
    @ViewBuilder
    private var rejectedSection: some View {
        if !viewModel.invitationsRejected.isEmpty || !viewModel.requestsRejected.isEmpty {
            Section {
                ForEach(viewModel.invitationsRejected) { request in
                    cell(for: request)
                }
                ForEach(viewModel.requestsRejected) { request in
                    cell(for: request)
                }
            } header: {
                HStack {
                    Text(String.Trip.manageRejectedSectionTitle)
                        .font(.avenirBody)
                        .bold()
                        .foregroundColor(.Main.black)
                    Spacer()
                }
            }
            .padding(.vertical, 12)

        }
    }
    
    private func deleteAction(participant: User) -> (() -> Void)? {
        if viewModel.isCurrentUserTripOrganiser {
            return {
                viewModel.deleteButtonAction(participant)
            }
        } else {
            return nil
        }
    }
    
}

extension TripManageMemebersView {
    
    private func cell(for request: TripRequest) -> some View {
        TripManageListCell(request: request, onAcceptUser: {
            viewModel.approve(request)
        }, onRejectUser: {
            viewModel.deny(request)
        }, onDeleteUser: deleteAction(participant: request.applicant))
        .onTapGesture {
            viewModel.selectedUser = request.applicant
        }
    }
    
    private func cell(for participant: User) -> some View {
        TripManageListCell(participant: participant,
                           isOrganiser: viewModel.trip.ownerId == participant.id,
                           onDeleteUser: deleteAction(participant: participant))
            .onTapGesture {
                viewModel.selectedUser = participant
            }
    }

}

struct TripManageMemebersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TripManageMemebersView(trip: Trip.testOngoing)
        }
    }
}
