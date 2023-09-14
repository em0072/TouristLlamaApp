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
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    
                    if !viewModel.isCurrentUser {
                        moreButton
                    } else {
                        logoutButton
                    }
                }
            }
            .fullScreenCover(item: $viewModel.userToEditProfile) { currentUser in
                EditProfileView(currentUser: currentUser)
            }
            .sheet(isPresented: $viewModel.isReportingViewOpen) {
                ReportingView(isLoading: viewModel.loadingState == .loading) { reason in
                    viewModel.reportUser(reason: reason)
                }
                .presentationDetents([.medium])
            }
            .confirmationDialog(viewModel.blockConfirmationTitle,
                                isPresented: $viewModel.isBlockingViewOpen,
                                titleVisibility: .visible,
                                actions: { blockConfirmationDialogActions },
                                message: { blockConfirmationDialogMessage })
            .confirmationDialog(String.Profile.logoutPromptTitle,
                                isPresented: $viewModel.isLogoutConfirmationShown,
                                actions: { logoutConfirmationDialogActions },
                                message: { logoutConfirmationDialogMessage })
            .onAppear {
                viewModel.getUserCounters()
            }
            .handle(loading: $viewModel.loadingState)
            .handle(error: $viewModel.error)
        }
    }
}

extension ProfileView {
    
    private var profileSummaryView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 40) {
                userImage
                userStats
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
        HStack(spacing: 30) {
            statsEntry(num: viewModel.counter?.tripsCount, title: String.Profile.trips)
//            statsEntry(num: 0, title: "Awards")
            statsEntry(num: viewModel.counter?.friendsCount, title: String.Profile.friends)
        }
//        .fixedSize(horizontal: true, vertical: false)
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
            } else {
                Capsule()
                    .frame(width: 100, height: 30)
                    .foregroundColor(.Main.grey)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }

    @ViewBuilder
    private var aboutView: some View {
        if let about = viewModel.user?.about, !about.isEmpty {
            Text(about)
                .font(.avenirBody)
                .foregroundColor(.Main.black)
                .opacity(0.8)
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
            NavigationLink {
                FriendsListView()
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
    
    private var moreButton: some View {
        Menu {
            reportMenuButton
            blockMenuButton
            
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 25, weight: .medium))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.Main.black, .thinMaterial)
            
        }
    }

    
    private var reportMenuButton: some View {
        Button {
            viewModel.reportUserButtonAction()
        } label: {
            Label(String.Main.report, systemImage: "exclamationmark.bubble.fill")
        }
    }
    
    private var blockMenuButton: some View {
        Button {
            viewModel.blockUserButtonAction()
        } label: {
            Label(viewModel.blockMenuButtonTitle, systemImage: viewModel.blockMenuButtonIcon)
        }
    }

    private var blockConfirmationDialogActions: some View {
        Button(viewModel.blockConfirmationActionString, role: .destructive) {
            viewModel.blockConfirmationAction()
        }
    }
    
    private var blockConfirmationDialogMessage: some View {
        Text(viewModel.blockConfirmationMessage)
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
    private var logoutButton: some View {
        if viewModel.isCurrentUser {
            Button(role: .destructive) {
                viewModel.logoutButtonAction()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.Main.accentRed)
            }
        }
    }
    
    @ViewBuilder
    private var logoutConfirmationDialogActions: some View {
        Button(String.Profile.logout, role: .destructive) {
            viewModel.logout()
        }
    }
    
    private var logoutConfirmationDialogMessage: some View {
        Text(String.Profile.logoutPromptMessage)
            .font(.avenirBody)
    }
    

}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
            ProfileView(user: .test)
    }
}
