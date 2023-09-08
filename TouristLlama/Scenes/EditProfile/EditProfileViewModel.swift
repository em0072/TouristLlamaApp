//
//  EditProfileViewModel.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 22/08/2023.
//

import SwiftUI
import Dependencies
import PhotosUI

//@MainActor
class EditProfileViewModel: ViewModel {
    
    @Dependency(\.userAPI) var userAPI
    
    @Published var currentUser: User
    @Published var fullName: String = ""
    @Published var username: String = ""
    @Published var pronoun: Pronoun = .none
    @Published var aboutMe: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var dateOfBirth: Date?
    @Published var profilePicture: String?

    @Published var pickedImage: PhotosPickerItem?
    @Published var newImage: UIImage?

    @Published var shouldDismiss: Bool = false
    @Published var isEditingUsername: Bool = false
    @Published var isLoadingImage: Bool = false
    @Published var isEditingAboutMe: Bool = false
    @Published var isShowingImageActionSheet: Bool = false
    @Published var isShowingImagePicker: Bool = false
    @Published var isShowingCameraPicker: Bool = false
    @Published var usernameCheckState: EditUsernameView.UsernameCheckState = .none


    init(currentUser: User) {
        self.currentUser = currentUser
        super.init()
        populateFields()
    }
    
    override func subscribeToUpdates() {
        super.subscribeToUpdates()
        subscribeToPickedImage()
    }
    
    var isDoneButtonDisabled: Bool {
        loadingState != .none || isLoadingImage
    }
    func editUsername() {
        isEditingUsername = true
    }
    
    func editAboutMe() {
        isEditingAboutMe = true
    }
    
    func checkUsernameAvailability(username: String) {
        guard username.count >= 3, username != self.username else {
            usernameCheckState = .none
            return
        }
        Task {
            do {
                self.usernameCheckState = .loading
                let isUsernameAvailable = try await userAPI.checkAvailability(of: username)
                self.usernameCheckState = isUsernameAvailable ? .available : .isTaken
            } catch {
                self.usernameCheckState = .none
                self.error = error
            }
        }
    }
    
    func changeUserName(to newUsername: String) {
        username = newUsername
    }
    
    func changeUserImageAction() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            isShowingImageActionSheet = true
        } else {
            openImagePicker()
        }
    }
    
    func openImagePicker() {
        isShowingImagePicker = true
    }
    
    func openCameraPicker() {
        isShowingCameraPicker = true
    }
    
    func updateUserInfo() {
        Task {
            do {
                
                var userProperties = [User.Property: Any]()
                guard username.count >= 3 else { return }
                loadingState = .loading
                if currentUser.name != fullName {
                    userProperties[.name] = fullName
                }
                if currentUser.name != fullName {
                    userProperties[.name] = fullName
                }
                
                if currentUser.username != username {
                    userProperties[.username] = username
                }
                
                if currentUser.pronoun != pronoun {
                    userProperties[.pronoun] = pronoun.rawValue
                }
                
                if currentUser.about != aboutMe {
                    userProperties[.about] = aboutMe
                }
                
                if currentUser.phone != phone {
                    userProperties[.phone] = phone
                }
                
                if currentUser.dateOfBirth != dateOfBirth {
                    userProperties[.dateOfBirth] = dateOfBirth?.timeIntervalSince1970Milliseconds
                }
                                
                if let newImage {
                    let profilePicture = try await uploadImageToServer(image: newImage)
                    userProperties[.profilePicture] = profilePicture
                }
                
                _ = try await userAPI.updateUserProperty(userProperties)
                shouldDismiss = true
            } catch {
                loadingState = .none
                self.error = error
            }
        }
    }
    
    private func uploadImageToServer(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            throw CustomError(text: "Can't convert UIImage to Data")
        }
        return try await userAPI.uploadProfilePicture(data: imageData)
    }
    
    private func populateFields() {
        fullName = currentUser.name
        username = currentUser.username
        pronoun = currentUser.pronoun
        aboutMe = currentUser.about
        
        email = currentUser.email
        phone = currentUser.phone
        dateOfBirth = currentUser.dateOfBirth
    }
    
    private func subscribeToPickedImage() {
        $pickedImage
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] pickedImage in
                self?.isLoadingImage = true
                Task { [weak self] in
                    if let data = try? await pickedImage?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        self?.newImage = image
                        self?.isLoadingImage = false
                    }
                }
            }
            .store(in: &publishers)
    }
    
}
