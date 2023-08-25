//
//  ProfileView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 21/08/2023.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    
    
    init(user: User? = nil) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    profileSummaryView
                    
                    if viewModel.isCurrentUser {
                        editProfileButton
                        
                        manageFriendsButton
                    }
//                    awardsButton
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle(viewModel.user?.username ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { settingsButton }
            }
            .fullScreenCover(item: $viewModel.userToEditProfile) { currentUser in
                EditProfileView(currentUser: currentUser)
            }
        }
    }
}

extension ProfileView {
    
    private var profileSummaryView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 40) {
                userImage
                userStats
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            nameView
            aboutView
        }
    }
    
    private var userImage: some View {
        KFImage(viewModel.user?.imageURL)
            .placeholder {
                UserImagePlaceholderView()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
    }
    
    private var userStats: some View {
        HStack(spacing: 18) {
            statsEntry(num: viewModel.counter?.tripsCount, title: String.Profile.trips)
//            statsEntry(num: 0, title: "Awards")
            statsEntry(num: viewModel.counter?.friendsCount, title: String.Profile.friends)
        }
    }
    
    private func statsEntry(num: Int?, title: String) -> some View {
        VStack(spacing: 0) {
            if let num {
                Text("\(num)")
                    .font(.avenirBigBody.weight(.heavy))
                    .foregroundColor(.Main.black)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            Text(title)
                .font(.avenirBody)
                .foregroundColor(.Main.black)
//                .fixedSize(horizontal: true, vertical: false)
//                .minimumScaleFactor(0.5)
                .opacity(0.8)
                .lineLimit(1)
        }
    }

    private var nameView: some View {
        HStack {
            if let name = viewModel.user?.name {
                Text(name)
                    .font(.avenirBigBody.weight(.heavy))
                    .foregroundColor(.Main.black)
//                if let pronouns = pronouns {
//                    Text(pronouns)
//                        .font(.avenirBody)
//                        .foregroundColor(.Main.black)
//                        .opacity(0.5)
//                }
            } else {
                Capsule()
                    .frame(width: 100, height: 30)
                    .foregroundColor(.Main.grey)
            }
        }
        .padding(.vertical, 5)
    }

    @ViewBuilder
    private var aboutView: some View {
        if let about = viewModel.user?.about, !about.isEmpty {
            VStack {
                Text(about)
                    .font(.avenirBody)
                    .foregroundColor(.Main.black)
                    .opacity(0.8)
            }
            .padding(.vertical, 10)
        }
    }
    
    private var editProfileButton: some View {
        Button {
            viewModel.openEditProfile()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.clear)
                    .border(Color.Main.TLBackgroundActive, width: 1)
                    .frame(height: 42)
                Text(String.Profile.editProfile)
                    .font(.avenirBody)
                    .foregroundColor(.Main.black)
                    .opacity(0.8)
            }
        }
        .padding(.vertical, 15)
    }
    
    private var dividerView: some View {
        Divider()
            .padding(.horizontal, 20)
    }
    
    private var manageFriendsButton: some View {
        VStack {
            Button {
//                viewModel.openManageFriendsView()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "person.fill.checkmark")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.Main.black)
                    VStack(alignment: .leading) {
                        Text(String.Profile.manageTrips)
                            .font(.avenirBody)
                            .bold()
                            .foregroundColor(.Main.black)
                        Text(String.Profile.manageTripsSubtitle)
                            .font(.avenirSmallBody.weight(.medium))
                            .foregroundColor(.Main.black)
                            .opacity(0.7)
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.Main.black)
                        .font(.system(size: 15, weight: .heavy))
                }
                
            }
            .padding(.bottom, 24)
            
            dividerView
        }
        .padding(.top, 24)
    }
    
//    private var awardsButton: some View {
//        VStack {
//            Button {
////                viewModel.openAwardsView()
//            } label: {
//                HStack(spacing: 15) {
//                    Image(systemName: "rosette")
//                        .font(.system(size: 25, weight: .heavy))
//                        .foregroundColor(.Main.black)
//                    VStack(alignment: .leading) {
//                        Text("Explore Awards")
//                            .font(.avenirBody)
//                            .bold()
//                            .foregroundColor(.Main.black)
//                        Text("Standout among everyone")
//                            .font(.avenirSmallBody.weight(.medium))
//                            .foregroundColor(.Main.black)
//                            .opacity(0.7)
//                    }
//                    Spacer()
//                    Image(systemName: "arrow.right")
//                        .foregroundColor(.Main.black)
//                        .font(.system(size: 15, weight: .heavy))
//                }
//
//            }
//            .padding(.bottom, 24)
//            dividerView
//        }
//        .padding(.top, 24)
//    }
    
    @ViewBuilder
    private var settingsButton: some View {
        if viewModel.isCurrentUser {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 17, weight: .medium))
            }
        }
//        Button {
//            viewModel.openSettings()
//        } label: {
//        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
            ProfileView(user: .test)
    }
}