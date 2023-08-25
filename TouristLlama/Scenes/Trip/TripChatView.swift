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
    
    @StateObject var viewModel: TripChatViewModel
    
    let title: String
    let chat: TripChat?
    
    init(title: String, chat: TripChat?) {
        self.title = title
        self.chat = chat
        self._viewModel = StateObject(wrappedValue: TripChatViewModel(chat: chat))
//        self._viewModel = StateObject(wrappedValue: TripChatViewModel(chat: chat))
//        self.viewModel.chat = chat
    }
    
    @FocusState private var focusState: KeyboardFocus?
        
    var body: some View {
        NavigationStack {
            ZStack {
                if let chat = viewModel.chat {
                    chatView(for: chat)
                } else {
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
            
        }
        .onChange(of: chat) { chat in
            viewModel.updateChat(with: chat)
        }
    }
    
}

extension TripChatView {
    
    private func chatView(for chat: TripChat) -> some View {
        VStack(spacing: 4) {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(chat.messages) { message in
                            messageCell(message: message,
                                        isTitleCell: viewModel.isFirstFormAuthor(message: message),
                                        isOutgoing: viewModel.isOutgoing(message: message))
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .scrollDismissesKeyboard(.interactively)
                .onTapGesture {
                    focusState = nil
                }
                .onAppear {
                    scrollViewProxy.scrollTo(chat.messages.last?.id)
                }
                .onChange(of: chat.messages) { messages in
                    withAnimation {
                        scrollViewProxy.scrollTo(messages.last?.id)
                    }
                }
                .onChange(of: focusState) { newFocus in
                    if focusState != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                scrollViewProxy.scrollTo(chat.messages.last?.id)
                            }
                        }
                    }
                }
            }
            messageInputView
        }
    }
    
    private func messageCell(message: ChatMessage, isTitleCell: Bool, isOutgoing: Bool) -> some View {
        ZStack {
            HStack {
                switch message.type {
                case .info:
                    chatInfoMessageView(message)
                case .user:
                    chatUserBubbleView(message, isTitleCell: isTitleCell, isOutgoing: isOutgoing)
                }
            }
        }
    }
    
    private func chatInfoMessageView(_ message: ChatMessage) -> some View {
        Text(message.text)
            .font(.avenirTagline)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Main.grey.opacity(0.3))
            }
    }
    
    private func chatUserBubbleView(_ message: ChatMessage, isTitleCell: Bool, isOutgoing: Bool) -> some View {
        HStack {
            if isOutgoing {
                HStack {
                    Spacer()
                }
            } else {
                authorImage(message.author?.imageURL, isTitleCell: isTitleCell)
            }
            
            HStack {
                if message.status == .error && isOutgoing {
                    Button {
                        viewModel.resend(message: message)
                    } label: {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.avenirSubtitle)
                            .foregroundStyle(Color.Main.TLStrongWhite, Color.Main.accentRed)
                    }

                }

                VStack(alignment: isOutgoing ? .trailing : .leading) {
                    if let authorName = message.author?.name, isTitleCell {
                        authorNameView(authorName, isOutgoing: isOutgoing)
                    }
                    chatMessageView(message.text)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(isOutgoing ? Color.Main.TLStrongWhite : Color.Main.black)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isOutgoing ? Color.Chat.outgoingBubble.opacity(message.status == .sending ? 0.6 : 1) : Color.Chat.incomingBubble)
                        .shadow(color: .Main.black.opacity(0.3), radius: 2, x: 0, y: 0)
                }
            }
            .padding(isOutgoing ? .leading : .trailing, 30)
            .padding(.top, isTitleCell ? 8 : 0)
            
            if !isOutgoing {
                Spacer()
//                    .padding(isOutgoing ? .leading : .trailing, 30)
            } else {
                authorImage(message.author?.imageURL, isTitleCell: isTitleCell)
            }
        }
    }
    
    private func chatMessageView(_ text: String) -> some View {
        Text(text)
            .font(.avenirBody)
    }
    
    private func authorNameView(_ authorName: String, isOutgoing: Bool) -> some View {
        HStack {
            Text(authorName)
                .font(.avenirTagline)
                .bold()
        }
    }
    
    @ViewBuilder
    private func authorImage(_ url: URL?, isTitleCell: Bool) -> some View {
        if isTitleCell {
            VStack {
                KFImage(url)
                    .placeholder {
                        UserImagePlaceholderView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .padding(.top, 12)
                
                Spacer()
            }
            
        } else {
            Color.clear
                .frame(width: 30, height: 30)
        }
    }
    
    private var messageInputView: some View {
        VStack {
            HStack(spacing: 0) {
                textFieldInputView
                
                sendButton
            }
            .padding(.trailing, 10)
        }
                    .background {
                        Color.Chat.inputBackground
                            .ignoresSafeArea()
                    }
    }
    
    private var textFieldInputView: some View {
        TextField("", text: $viewModel.chatMessageText, axis: .vertical)
            .font(.avenirBody)
            .foregroundColor(Color.Main.TLText)
            .tint(Color.Main.accentBlue)
            .lineLimit(5)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .focused($focusState, equals: .inputField)
            .background {
                Capsule()
                    .fill(Color.Chat.inputTextFieldBackground)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .shadow(color: .Main.black.opacity(0.1), radius: 2, x: 0, y: 0)
    }
    
    private var sendButton: some View {
        Button {
            viewModel.sendChatMessage()
        } label: {
            Image(systemName: "paperplane.circle.fill")
                .foregroundStyle(Color.Main.TLStrongWhite,
                                 viewModel.chatMessageText.isEmpty ? Color.Main.grey : Color.Main.accentBlue)
                .font(.avenirSubline)
        }
        .opacity(viewModel.chatMessageText.isEmpty ? 0.3 : 1)
        .disabled(viewModel.chatMessageText.isEmpty)
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
        TripChatView(title: "New chat", chat: .test(numberOfMessages: 55))
    }
}
