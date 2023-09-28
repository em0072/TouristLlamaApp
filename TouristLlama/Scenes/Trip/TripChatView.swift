//
//  TripChatsListView.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 16/08/2023.
//

import SwiftUI
import Kingfisher

struct TripChatView: View {
    
    enum KeyboardFocus {
        case inputField
    }
    
    @Environment(\.dismiss) private var dismiss

    let title: String
    @StateObject var viewModel: TripChatViewModel
    
    @State private var wholeSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var isUIInitiallyLoaded =  false
    @State private var incomingMessage =  false
    @State private var messageIdOnScreen: String?
    @State private var scrollPositionId: String?
    @State private var scrollToBottom: Bool = false
    
    let chatEndId = "chatEnd"
    let chatNewMessagesId = "newMessages"

    @FocusState private var focusState: KeyboardFocus?
        
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
                                print("Media Button Press")
                            } onSendButtonPress: { text in
                                viewModel.sendChatMessage(chatMessageText: text)
                            }
                            .ignoresSafeArea()
//                        }
                    }
                case .loading:
                    loaderView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
            }
            .animation(.default, value: viewModel.shouldShowScrollButton)
        }
    }
    
}

extension TripChatView {
    
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
