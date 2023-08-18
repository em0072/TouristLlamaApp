//
//  TripDetailsView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI
import MapKit

struct TripDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: TripViewModel
    
    @State private var scrollViewOffset: CGPoint = CGPoint.zero
    
    var body: some View {
        NavigationStack {
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
            //        .sheet(isPresented: $viewModel.openUserManagment, onDismiss: nil, content: {
            //            NavigationView {
            //                TripManageMemebersView(trip: viewModel.trip)
            //            }
            //            .accentColor(.TLBlack)
            //        })
            .padding(.top, -8)
            .ignoresSafeArea(.all, edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack(spacing: 8) {
                            editButton
                            shareButton
                        }
                }
            }

        }
        
    }
}

    
extension TripDetailsView {
    
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
    
    private var imageView: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                AsyncImage(url: viewModel.tripImageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height + max(0, geometry.frame(in: .global).minY))
                        .clipped()
                        .offset(y: -(max(0, geometry.frame(in: .global).minY)))
                } placeholder: {
                    Color.Main.TLInactiveGrey
                }
            }.frame(height: 390)

            LinearGradient(colors: [.clear, .clear, .clear, .black], startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                Text(viewModel.trip.name)
                    .font(.avenirSubtitle)
                    .bold()
                    .foregroundColor(.Main.TLStrongWhite)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(viewModel.trip.location.nameAndFlag)
                    .font(.avenirBody.weight(.medium))
                    .foregroundColor(.Main.TLStrongWhite)
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
//                            ProfileView()
                            Text("Current User \(participant.name)")
                        } else {
                            Text("User Profile \(participant.name)")
//                            UserProfileView(user: participant)
                        }
                    } label: {
                        userView(for: participant)
                    }
                }
                NavigationLink {
                    Text("Manage Members")
//                    TripManageMemebersView(trip: viewModel.trip)
                } label: {
                    HStack {
                        Text("Invite & Manage Team Members")
                            .font(.avenirBody)
                            .bold()
                            .foregroundColor(.Main.black)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(.Main.black)
                            .font(.system(size: 15, weight: .heavy))
                    }
                }
                .padding(.top, 20)

                
//                Button {
//                    viewModel.openUserManagment.toggle()
//                } label: {
//                    HStack {
//                        Text("Invite & Manage Team Members")
//                            .font(.TLBody.weight(.heavy))
//                            .foregroundColor(.TLBlack)
//                        Spacer()
//                        Image(systemName: "arrow.right")
//                            .foregroundColor(.TLBlack)
//                            .font(.system(size: 15, weight: .heavy))
//                    }
//                }
//                .padding(.top, 20)
                
            }
        }
        .padding(20)
        
    }
    
    private func userView(for user: User) -> some View {
        HStack(alignment: .center) {
            AsyncImage(url: user.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                UserImagePlaceholderView()
            }
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
            TripDetailsView(viewModel: TripViewModel(trip: .testOngoing))
    }
}
