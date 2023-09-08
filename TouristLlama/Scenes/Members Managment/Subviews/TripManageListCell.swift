//
//  TripManageListCell.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 29/08/2023.
//

import SwiftUI
import Kingfisher

struct TripManageListCell: View {
    
    private let participant: User
    private let request: TripRequest?
    private let isOrganiser: Bool
    private let onAcceptUser: (() -> Void)?
    private let onDeleteUser: (() -> Void)?
    private let onRejectUser: (() -> Void)?
    
    @State private var isExpanded: Bool = false
    
    init(participant: User, isOrganiser: Bool, onDeleteUser: (() -> Void)? = nil) {
        self.participant = participant
        self.request = nil
        self.isOrganiser = isOrganiser
        self.onAcceptUser = nil
        self.onRejectUser = nil
        self.onDeleteUser = onDeleteUser
    }
    
    init(request: TripRequest, onAcceptUser: (() -> Void)? = nil, onRejectUser: (() -> Void)? = nil, onDeleteUser: (() -> Void)? = nil) {
        self.participant = request.applicant
        self.request = request
        self.isOrganiser = false
        self.onAcceptUser = onAcceptUser
        self.onRejectUser = onRejectUser
        self.onDeleteUser = onDeleteUser
    }
    
    var body: some View {
        cellContent
            .animation(.default, value: isExpanded)

    }
    
}

extension TripManageListCell {
    
    private var cellContent: some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                userImage
                userName
                Spacer()
                
                requestButtonsView
                
                userStatus
            }
            
            requestSection
                .onTapGesture {
                    isExpanded.toggle()
                }
            
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if shouldShowDeleteButton {
                Button(role: .destructive) {
                    onDeleteUser?()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
        
    @ViewBuilder
    private var requestSection: some View {
        if let request, request.status == .requestPending, !request.applicationLetter.isEmpty {
            HStack {
                Text(request.applicationLetter)
                    .lineLimit(isExpanded ? nil : 2)
                    .font(.avenirBody)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.thickMaterial)
                    }

                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var requestButtonsView: some View {
        if let request, request.status == .requestPending {
            HStack {
                Button {
                    onAcceptUser?()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.Main.green)
                        .font(.avenirTitle)
                        .padding(8)
                }
                
                Button {
                    onRejectUser?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.Main.accentRed)
                        .font(.avenirTitle)
                        .padding(8)
                }
            }
        }
    }
    
    private var userImage: some View {
        KFImage(participant.imageURL)
            .placeholder({ UserImagePlaceholderView() })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 35, height: 35)
            .clipShape(Circle())
    }
    
    private var userName: some View {
        Text(participant.name)
            .font(.avenirBody)
            .foregroundColor(.Main.black)
    }
    
    @ViewBuilder
    private var userStatus: some View {
        if isOrganiser {
            Text(String.Trip.organizer)
                .font(.avenirBody)
                .foregroundColor(.Main.black)
                .opacity(0.8)
        } else if request?.status == .invitePending {
            Text(String.Trip.invitedUser)
                .font(.avenirBody)
                .foregroundColor(.Main.black)
                .opacity(0.5)
        } else if request?.status == .inviteRejected {
            Text(String.Trip.inviteRejected)
                .font(.avenirBody)
                .foregroundColor(.Main.accentRed)
                .opacity(0.7)
        } else if request?.status == .requestRejected {
            Text(String.Trip.requestRejected)
                .font(.avenirBody)
                .foregroundColor(.Main.accentRed)
                .opacity(0.7)
        }
    }
    
    @ViewBuilder
    private var organiserLabelView: some View {
        if isOrganiser {
            Text(String.Trip.organizer)
                .font(.avenirBody)
                .foregroundColor(.Main.black)
                .opacity(0.5)
        }
    }
    
    private var shouldShowDeleteButton: Bool {
        let hasDeleteAction = onDeleteUser != nil
        let isInvitePending = request?.status == .invitePending
        let isRequested = request?.status == .requestPending || request?.status == .requestRejected
        let inviteRejected = request?.status == .inviteRejected
        return hasDeleteAction && !isOrganiser && (!isRequested || isInvitePending) && !inviteRejected
    }
    
}

struct TripManageListCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TripManageListCell(participant: .test, isOrganiser: true, onDeleteUser: {})
            TripManageListCell(participant: .test, isOrganiser: false, onDeleteUser: {})
            TripManageListCell(request: .testInvitationPending, onDeleteUser: {})
            TripManageListCell(request: .testInvitationRejected, onDeleteUser: {})
            TripManageListCell(request: .testRequestPending, onDeleteUser: {})
            TripManageListCell(request: .testRequestRejected, onDeleteUser: {})

        }
    }
}
