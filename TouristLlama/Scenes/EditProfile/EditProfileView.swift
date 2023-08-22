//
//  EditProfileView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import SwiftUI
import PhotosUI


struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: EditProfileViewModel
    
    init(currentUser: User) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(currentUser: currentUser))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                imageButtonView
                    .tint(.Main.accentBlue)
                    .withDivider()
                
                generalInfoView
                    .padding(.vertical, 12)
                    .withDivider()
                
                personalInfoSettingsButton
                    .withDivider()
            }
            .padding(.horizontal, 20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(String.Profile.editProfile)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    doneButton
                }
            })
        }
        .confirmationDialog(String.Profile.editProfilePictureTitle,
                            isPresented: $viewModel.isShowingImageActionSheet,
                            actions: {
            Button(String.Main.camera) {
                viewModel.openCameraPicker()
            }
            Button(String.Main.photoLibrary) {
                viewModel.openImagePicker()
            }
        }, message: {
            Text(String.Profile.editProfilePictureSubtitle)
        })
        .photosPicker(isPresented: $viewModel.isShowingImagePicker, selection: $viewModel.pickedImage)
        .cameraPicker(isPresented: $viewModel.isShowingCameraPicker, selection: $viewModel.newImage)
        .onChange(of: viewModel.shouldDismiss, perform: { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        })
        .handle(loading: $viewModel.loadingState)
        .handle(error: $viewModel.error)
    }
}

extension EditProfileView {
    
    private var generalInfoView: some View {
        VStack(spacing: 20) {
            FramedTextField(title: String.Profile.fullName,
                            prompt: String.Profile.fullName,
                            value: $viewModel.fullName,
                            showDeleteButton: false)
            
            NavigationLink {
                EditUsernameView(username: viewModel.username,
                                 state: viewModel.usernameCheckState) { usernameToCheck in
                    viewModel.checkUsernameAvailability(username: usernameToCheck)
                } onUsernameChange: { newUsername in
                    viewModel.changeUserName(to: newUsername)
                }
                
            } label: {
                Button(String.Profile.username) {}
                    .buttonStyle(FramedButtonStyle(value: $viewModel.username))
                    .disabled(true)
            }
            .buttonStyle(.plain)
            
            FramedPickerView(title: String.Profile.pronoun,
                             placeholder: String.Profile.pronoun,
                             selected: $viewModel.pronoun,
                             emptyState: Pronoun.none)
            
            NavigationLink {
                EditAboutView(about: $viewModel.aboutMe)
            } label: {
                Button(String.Profile.aboutMe) {}
                    .buttonStyle(FramedButtonStyle(value: $viewModel.aboutMe))
                    .disabled(true)
            }
            .buttonStyle(.plain)
            
        }
    }
    
    private var personalInfoSettingsButton: some View {
        NavigationLink {
            EditPersonalInfoView(email: $viewModel.email,
                                 phone: $viewModel.phone,
                                 dateOfBirth: $viewModel.dateOfBirth)
        } label: {
            HStack(spacing: 15) {
                Text(String.Profile.personalInformationSettings)
                    .font(.body)
                    .bold()
                    .foregroundColor(.Main.black)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(.Main.black)
                    .font(.system(size: 15, weight: .heavy))
            }
            .padding(.vertical, 20)
        }
    }
    
    private var imageButtonView: some View {
//        PhotosPicker
        //        PhotosPicker(selection: $viewModel.pickedImage, matching: .images, preferredItemEncoding: .compatible) {
        //            VStack {
        //                imageView
        //                    .overlay {
        //                        if viewModel.isLoadingImage {
        //                            ZStack {
        //                                Color.black.opacity(0.5)
        //
        //                                ProgressView()
        //                                    .progressViewStyle(.circular)
        //                                    .tint(.Main.TLStrongWhite)
        //                            }
        //                        }
        //                    }
        //                    .padding(.bottom, 16)
        //
        //                Text(String.Profile.changeProfilePhoto)
        //                    .font(.avenirTagline)
        //                    .bold()
        //            }
        //        }
        
        Button {
            viewModel.changeUserImageAction()
        } label: {
            VStack {
                imageView
                    .padding(.bottom, 16)
                Text(String.Profile.changeProfilePhoto)
                    .font(.avenirTagline)
                    .bold()
                
            }
        }
        .padding(.vertical, 16)
    }
    
    private var imagePickerView: some View {
        PhotosPicker(selection: $viewModel.pickedImage, matching: .images, preferredItemEncoding: .compatible) {
            VStack {
                imageView
                    .overlay {
                        if viewModel.isLoadingImage {
                            ZStack {
                                Color.black.opacity(0.5)
                                
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.Main.TLStrongWhite)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                
                Text(String.Profile.changeProfilePhoto)
                    .font(.avenirTagline)
                    .bold()
            }
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let newImage = viewModel.newImage {
            Image(uiImage: newImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120,height: 120)
                .clipShape(Circle())
        } else {
            AsyncImage(url: viewModel.currentUser.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                UserImagePlaceholderView()
            }
            .frame(width: 120,height: 120)
            .clipShape(Circle())
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text(String.Main.cancel)
                .font(.avenirBigBody.weight(.medium))
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            viewModel.updateUserInfo()
        }) {
            Text(String.Main.done)
                .font(.avenirBigBody)
                .bold()
        }
        .tint(.Main.accentBlue)
        .disabled(viewModel.isDoneButtonDisabled)
    }
    
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(currentUser: .test)
    }
}
