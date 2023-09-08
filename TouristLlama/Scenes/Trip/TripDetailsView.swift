//
//  TripDetailsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI
import MapKit
import Kingfisher

struct TripDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: TripDetailViewModel
    
    @State private var scrollViewOffset: CGPoint = CGPoint.zero
    
    let onTripEdit: () -> Void
    let trip: Trip
    
    init(trip: Trip, isMembersManagmentOpen: Bool, onTripEdit: @escaping () -> Void) {
        self.trip = trip
        self._viewModel = StateObject(wrappedValue: TripDetailViewModel(trip: trip, isMembersManagmentOpen: isMembersManagmentOpen))
        self.onTripEdit = onTripEdit
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) { offset in
                    scrollViewOffset = offset
                } content: {
                    VStack(alignment: .leading, spacing: 0) {
                        imageView
                        datesView
                        dividerView
                        aboutView
                        dividerView
                        paticipantsView
                        dividerView
                        mapView
                    }
                }
                .padding(.top, -8)
                .safeAreaInset(edge: .bottom, content: {
                    Spacer()
                        .frame(height: viewModel.tripDetailViewBottomOffsetAmount)
                })
                .ignoresSafeArea(.all, edges: .top)
                
                joinView
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(spacing: 8) {
                        if viewModel.isCurrentUserOwnerOfTrip {
                            editButton
                        }
                        //                            shareButton
                        moreButton
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isMembersManagmentOpen) {
                TripManageMemebersView(trip: viewModel.trip)
            }
            .confirmationDialog("", isPresented: $viewModel.isLeaveTripConfirmationShown, actions: {
                leaveTripButton
            }, message: {
                Text(String.Trip.leaveTripMessage)
                    .font(.avenirBody)
            })
            .confirmationDialog("", isPresented: $viewModel.isDeleteTripConfirmationShown, actions: {
                deleteTripButton
            }, message: {
                Text(String.Trip.deleteTripMessage)
                    .font(.avenirBody)
            })
            .sheet(item: $viewModel.sheetType, content: { type in
                sheetView(for: type)
            })
            .animation(.default, value: viewModel.nonParticipantTripRequest)

            
        }
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
        .onChange(of: trip) { trip in
            viewModel.trip = trip
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        
    }
}


extension TripDetailsView {
    
    @ViewBuilder
    private func sheetView(for type: TripDetailViewModel.SheetType) -> some View {
        switch type {
        case .report:
            ReportingView(isLoading: viewModel.loadingState == .loading) { reason in
                viewModel.reportTrip(reason: reason)
            }
            .presentationDetents([.medium])

        case .applicationLetter:
            TripApplicationForm { message in
                viewModel.joinRequestSend(message: message)
            }
            .presentationDragIndicator(.visible)
            .handle(loading: $viewModel.loadingState)
            .handle(error: $viewModel.error)
        }
    }
    
    @ViewBuilder
    private var joinView: some View {
        if !viewModel.isCurrentUserMemberOfTrip {
            VStack(spacing: 0) {
                Spacer()
                
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
        }
    }
    
    private var joinButtonView: some View {
        Button(String.Trip.requestToJoin) {
            viewModel.joinButtonAction()
        }
        .buttonStyle(WideBlueButtonStyle())
        .padding(.top, 12)
        .padding(.horizontal, 20)
        .background {
            joinBackgroundView(color: .clear)
        }
    }
    
    private func requestPendingView(request: TripRequest) -> some View {
        HStack {
            Spacer()
            VStack {
                Text(String.Trip.requestToJoinPending)
                    .foregroundStyle(.primary)
                    .font(.avenirBody)
                    .bold()
                
                Button {
                    viewModel.cancelJoinRequest(request)
                } label: {
                    Text(String.Main.cancel)
                        .font(.avenirBody)
                        .foregroundStyle(.primary)
                        .underline()
                }
            }
            .padding(.top, 12)
            Spacer()
        }
        .background {
            joinBackgroundView(color: .Main.yellow)
        }
    }
    
    private func invitePendingView(request: TripRequest) -> some View {
        HStack {
            Spacer()
            VStack {
                Text(String.Trip.inviteToJoinPending)
                    .foregroundStyle(.primary)
                    .font(.avenirBody)
                    .bold()
                
                HStack {
                    Button {
                        viewModel.acceptInvite(request)
                    } label: {
                        Text(String.Main.accept)
                            .font(.avenirBody)
                            .foregroundStyle(.primary)
                            .bold()
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
                            .foregroundStyle(.primary)
                            .bold()
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
            joinBackgroundView(color: .Main.yellow)
        }
        
    }
    
    private var requestRejectedView: some View {
        HStack {
            
            Spacer()
            
            VStack {
                Text(String.Trip.requestToJoinRejected)
                    .foregroundStyle(.primary)
                    .font(.avenirBody)
                    .bold()
                
                Button {
                    viewModel.joinButtonAction()
                } label: {
                    Text(String.Trip.requestToJoinAgain)
                        .foregroundStyle(.primary)
                        .font(.avenirBody)
                        .underline()
                }
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .background {
            joinBackgroundView(color: .Main.accentRed)
        }
    }
    
    private var inviteRejectedView: some View {
        HStack {
            
            Spacer()
            
            VStack {
                Text(String.Trip.inviteToJoinRejected)
                    .foregroundStyle(.primary)
                    .font(.avenirBody)
                    .bold()
                
                Button {
                    viewModel.joinButtonAction()
                } label: {
                    Text(String.Trip.requestToJoinAgain)
                        .foregroundStyle(.primary)
                        .font(.avenirBody)
                        .underline()
                }
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .background {
            joinBackgroundView(color: .Main.accentRed)
        }
    }
    
    private func joinBackgroundView(color: Color) -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .background {
                color.opacity(0.6)
            }
            .ignoresSafeArea()
        
    }

    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, .thinMaterial)
        }
    }
    
    private var shareButton: some View {
        Button {
            
        } label: {
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, .thinMaterial)
        }
    }
    
    private var moreButton: some View {
        Menu {
            if viewModel.isCurrentUserMemberOfTrip && !viewModel.isCurrentUserOwnerOfTrip {
                leaveTripMenuButton
            }
            if viewModel.isCurrentUserOwnerOfTrip {
                deleteTripMenuButton
            }
            if !viewModel.isCurrentUserOwnerOfTrip {
                reportMenuButton
            }
            
            
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, .thinMaterial)
            
        }
    }
    
    private var leaveTripMenuButton: some View {
        Button(role: .destructive) {
            viewModel.showLeaveTripConfirmation()
        } label: {
            Label(String.Trip.leaveTrip, systemImage: "figure.walk.departure")
        }
        
    }
    
    private var leaveTripButton: some View {
        Button(String.Trip.leaveTrip, role: .destructive) {
            viewModel.leaveTrip()
        }
    }
    
    private var deleteTripMenuButton: some View {
        Button(role: .destructive) {
            viewModel.showDeleteTripConfirmation()
        } label: {
            Label(String.Trip.deleteTrip, systemImage: "trash.fill")
        }
    }
    
    private var deleteTripButton: some View {
        Button(String.Trip.deleteTrip, role: .destructive) {
            viewModel.deleteTrip()
        }
    }
    
    private var reportMenuButton: some View {
        Button {
            viewModel.reportTripButtonAction()
        } label: {
            Label(String.Main.report, systemImage: "exclamationmark.bubble.fill")
        }
    }
    
    
    private var editButton: some View {
        Button {
            onTripEdit()
        } label: {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, .thinMaterial)
        }
    }
    
    private var imageView: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                KFImage(viewModel.tripImageURL)
                    .placeholder {
                        Color.Main.TLInactiveGrey
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height + max(0, geometry.frame(in: .global).minY))
                    .clipped()
                    .offset(y: -(max(0, geometry.frame(in: .global).minY)))
            }.frame(height: 390)
            
            LinearGradient(colors: [.clear, .clear, .Main.white], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                Text(viewModel.trip.name)
                    .font(.avenirSubtitle)
                    .bold()
                    .foregroundColor(.Main.black)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(viewModel.trip.location.nameAndFlag)
                    .font(.avenirBody.weight(.medium))
                    .foregroundColor(.Main.black)
            }
            .padding(20)
        }
    }
    
    private var imageHeight: CGFloat {
        let height: CGFloat = 390
        let offset = scrollViewOffset.y
        if offset > 0 {
            return height + offset
        } else {
            return height
        }
    }
    
    private var scrollViewTopImageOffset: CGFloat {
        let offset = scrollViewOffset.y
        if offset > 0 {
            return offset * -1
        } else {
            return 0
        }
    }
    
    private func titleView(_ text: String) -> some View {
        Text(text)
            .font(.avenirBigBody)
            .bold()
            .foregroundColor(.Main.black)
            .padding(.bottom, 12)
    }
    
    private func bodyView(_ text: String) -> some View {
        Text(text)
            .font(.avenirBody.weight(.medium))
            .foregroundColor(.Main.black)
    }
    
    private var dividerView: some View {
        Divider()
            .padding(.horizontal, 20)
    }
    
    private var datesView: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView(String.Trip.datesTitle)
            bodyView(viewModel.tripDatesText)
                .padding(.bottom, 3)
            Text(viewModel.numberOfNightsText)
                .font(.avenirBody.weight(.heavy))
                .foregroundColor(.Main.black)
                .opacity(0.8)
                .padding(.top, 5)
            
        }
        .padding(20)
    }
    
    @ViewBuilder
    private var aboutView: some View {
        if !viewModel.trip.description.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                titleView(String.Trip.aboutTitle)
                bodyView(viewModel.trip.description)
                    .padding(.bottom, 20)
                dividerView
            }
            .padding([.top, .horizontal], 20)
        } else {
            EmptyView()
        }
        //        .padding(.bottom, 24)
    }
    
    private var paticipantsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView(String.Trip.paticipantsTitle)
            VStack {
                ForEach(viewModel.trip.participants) { participant in
                    NavigationLink {
                        if viewModel.isCurrentUser(participant) {
                            ProfileView(user: participant)
                        } else {
                            ProfileView(user: participant)
                        }
                    } label: {
                        userView(for: participant)
                    }
                }
                
                if viewModel.isCurrentUserOwnerOfTrip {
                    Button {
                        viewModel.openMembersManagment()
                    } label: {
                        HStack {
                            Text(String.Trip.manageMembersSubitle)
                                .font(.avenirBody)
                                .bold()
                                .foregroundColor(.Main.black)
                            Spacer()
                            
                            if viewModel.hasPendingRequests {
                                Circle()
                                    .fill(Color.Main.accentRed)
                                    .frame(width: 25, height: 25)
                                    .overlay {
                                        Text("\(viewModel.pendingRequestsCount)")
                                            .font(.avenirSmallBody)
                                    }
                            }
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.Main.black)
                                .font(.system(size: 15, weight: .heavy))
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .padding(20)
        
    }
    
    private func userView(for user: User) -> some View {
        HStack(alignment: .center) {
            KFImage(user.imageURL)
                .placeholder {
                    UserImagePlaceholderView()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            Text(user.name)
                .font(.avenirBody.weight(.medium))
                .foregroundColor(.Main.black)
            Spacer()
            
            if viewModel.trip.ownerId == user.id { //TripHelper.is(viewModel.trip, orginisedBy: user) {
                Text(String.Trip.organizer)
                    .font(.avenirBody.weight(.medium))
                    .foregroundColor(.Main.black)
                    .opacity(0.5)
            }
        }
    }
    
    @ViewBuilder
    private var mapView: some View {
        if let latitude = viewModel.trip.location.point?.coordinate.latitude,
           let longitude = viewModel.trip.location.point?.coordinate.longitude {
            VStack(alignment: .leading, spacing: 0) {
                titleView(String.Trip.mapTitle)
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), interactionModes: [.all])
                    .frame(height: 230)
                    .cornerRadius(24)
                
            }
            .padding(20)
        } else {
            EmptyView()
        }
        
    }
}

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView(trip: .testOngoing, isMembersManagmentOpen: false, onTripEdit: {})
    }
}
