//
//  TripChatsListView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI
import Kingfisher

struct TripChatView: View {
    
    @Environment(\.dismiss) private var dismiss

    let title: String
    @StateObject var viewModel: TripChatViewModel
        
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .content:
                    if let currentUser = viewModel.userAPI.currentUser,
                       let chat = viewModel.chat {
                            MessagesView(currentUser: currentUser, chat: chat, chatParticipants: viewModel.chatParticipants, messages: $viewModel.messages) { message, isShown in
                                if isShown {
                                    viewModel.messageAppeared(message)
                                }                                
                            } onMediaButtonPress: {
                                viewModel.mediaButtonAction()
                            } onSendButtonPress: { text in
                                viewModel.sendChatMessage(chatMessageText: text)
                            }
                            .ignoresSafeArea()
                    }
                case .loading:
                    loaderView
                }
            }
            .confirmationDialog("", isPresented: $viewModel.isMediaPickerSheetPresented, actions: {
                cameraButton
                photoLibraryButton
            })
            .cameraPicker(isPresented: $viewModel.isCameraOpen, selection: $viewModel.cameraImageToSend)
            .photosPicker(isPresented: $viewModel.isPhotoLibraryOpen, selection: $viewModel.photoLibraryImagesToSend, photoLibrary: .shared())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
            }
            .handle(loading: $viewModel.loadingState)
            .animation(.default, value: viewModel.shouldShowScrollButton)
        }
    }
    
}

extension TripChatView {
    
    private var cameraButton: some View {
            Button(String.Main.camera) {
                viewModel.cameraButtonAction()
            }
    }
    
    private var photoLibraryButton: some View {
            Button(String.Main.photoLibrary) {
                viewModel.photoLibraryButtonAction()
            }
    }
    
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
    
    
    private var loaderView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct TripChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        TripChatView(title: "Trip Chat", viewModel: .init())
    }
}
