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
    
    let chatEndId = "chatEnd"
    let chatNewMessagesId = "newMessages"

    
//    let chat: TripChat?
//    let selected: Bool
    
//    init(title: String, chat: TripChat?, selected: Bool = true) {
//        self.title = title
//        self.chat = chat
//        self.selected = selected
//        self._viewModel = StateObject(wrappedValue: TripChatViewModel(chat: chat))
//    }
    
//    init(title: String, viewModel: TripChatViewModel) {
//        self._viewModel = St
//    }
    
    @FocusState private var focusState: KeyboardFocus?
        
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .content:
                    VStack(spacing: 0) {
                        chatView(messages: viewModel.messages)
                        
                        messageInputView
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
        .onChange(of: viewModel.messages) { [oldMessages = viewModel.messages] newMessages in
            guard oldMessages.first?.id == newMessages.first?.id else {
                scrollViewProxy?.scrollTo(oldMessages.first?.id, anchor: .top)
                return
            }
            guard !oldMessages.isEmpty else {
                return
            }
            incomingMessage = true
            scrollToBottom()
        }
        .onChange(of: focusState) { newFocusState in
            if newFocusState != nil && !viewModel.shouldShowScrollButton {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    scrollToBottom()
                }
            }
        }        
    }
    
}

extension TripChatView {
    
    private func scrollToBottom(animated: Bool = true) {
        withAnimation(animated ? .default : .none) {
            scrollViewProxy?.scrollTo(chatEndId)
        }
    }
    
    private func scrollToNewMessagesPlack(animated: Bool = true) {
        withAnimation(animated ? .default : .none) {
            scrollViewProxy?.scrollTo(chatNewMessagesId, anchor: .center)
        }
    }

    private func chatView(messages: [ChatMessage]) -> some View {
        
        ScrollViewReader { scrollProxy in
            ChildSizeReader(size: $scrollViewSize) {
                ZStack {
                    chatScrollView(messages: messages)
                    scrollDownButton
                }
            }
            .onAppear {
                scrollViewProxy = scrollProxy
                if viewModel.messages.contains(where: { $0.type == .newMessages }) {
                    scrollToNewMessagesPlack(animated: false)
                } else {
                    scrollToBottom(animated: false)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isUIInitiallyLoaded = true
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    private func chatScrollView(messages: [ChatMessage]) -> some View {
        ScrollView(showsIndicators: false) { offset in
            guard isUIInitiallyLoaded else { return }
            if abs(offset.y) + 30 >=  wholeSize.height - scrollViewSize.height {
                viewModel.markEndOfChat(isEnd: true)
                incomingMessage = false
            } else {
                if !incomingMessage {
                    viewModel.markEndOfChat(isEnd: false)
                }
            }
        } content: {
            ChildSizeReader(size: $wholeSize) {
                
                LazyVStack(spacing: 0) {
                    Color.clear
                        .frame(height: 10)
                        .onAppear {
                            guard isUIInitiallyLoaded else { return }
                            viewModel.downloadOlderMessages()
                        }

                    ForEach(viewModel.messages) { message in
                        ZStack {
                            switch message.type {
                            case .user:
                                userMessageCell(message: message, isTitle: viewModel.isTitleMessage(message))
                                    .id(message.id)

                            case .newMessages:
                                newMesasgesCell
                                    .id(chatNewMessagesId)

                            case .info:
                                infoMessageCell(message)
                            }
                        }
                        .onAppear {
                            viewModel.markAsRead(message)
                        }
                    }
                    Color.clear
                        .frame(height: 10)
                        .id(chatEndId)
                }
            }
        }
//        .scrollPo
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            focusState = nil
        }
        .onAppear {
            viewModel.markEndOfChat(isEnd: true)
        }
    }
    
    @ViewBuilder
    private var scrollDownButton: some View {
        if viewModel.shouldShowScrollButton {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        scrollToBottom()
                    } label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.Main.black, .thinMaterial)
                    }
                    .padding(10)
                }
            }
        }
    }
    
    @ViewBuilder
    private func userMessageCell(message: ChatMessage, isTitle: Bool) -> some View {
        if viewModel.isMessageFromCurrentUser(message) {
            outgoingMessageCell(message: message, isTitle: isTitle)
        } else {
            incomingMessageCell(message: message, isTitle: isTitle)
        }
    }
    
    private func outgoingMessageCell(message: ChatMessage, isTitle: Bool) -> some View {
        var topPadding: CGFloat = 4
        if isTitle {
            topPadding = 12
        }
        
        return HStack(spacing: 0) {
            Spacer()
            Text(message.text)
                .font(.avenirBody)
                .foregroundColor(.Main.strongWhite)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.Chat.outgoingBubble)
                }
            
            messageStatusIconView(message: message)
        }
        .padding(.top, topPadding)
        .padding(.leading, 40)
    }
    
    private func incomingMessageCell(message: ChatMessage, isTitle: Bool) -> some View {
        var topPadding: CGFloat = 4
        var isTitleCell = false
        if isTitle {
            topPadding = 12
            isTitleCell = true
        }

        return HStack {
            
            authorImageView(message.author?.imageURL, isTitleCell: isTitleCell)

            VStack(alignment: .leading) {
                if isTitleCell {
                    authorNameView(message.author?.name)
                }
                Text(message.text)
                    .font(.avenirBody)
                    .foregroundColor(.Main.black)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.Chat.incomingBubble)
            }

            
            Spacer()
        }
        .padding(.top, topPadding)
        .padding(.trailing, 40)
    }

    @ViewBuilder
    private func messageStatusIconView(message: ChatMessage) -> some View {
        switch message.status {
            
        case .sending:
            VStack {
                Spacer()
                Image(systemName: "clock")
                    .font(.avenirCaption)
            }

        case .sent:
            VStack {
                Spacer()
                Image(systemName: "checkmark")
                    .font(.avenirCaption)
            }

        case .error:
            Button {
                viewModel.resend(message: message)
            } label: {
                Image(systemName: "exclamationmark.octagon.fill")
                    .font(.avenirSubtitle)
                    .foregroundColor(.Main.accentRed)
                    .padding(.leading, 8)
            }

        case .none:
            EmptyView()
        }
//        if message.status == .sending {
//            VStack {
//                Spacer()
//                Image(systemName: "clock")
//                    .font(.avenirCaption)
//            }
//        } else if message.status == .sent {
//            VStack {
//                Spacer()
//                Image(systemName: "checkmark")
//                    .font(.avenirCaption)
//            }
//
//        } else if message.status == .error {
//            Button {
//                viewModel.resend(message: message)
//            } label: {
//                Image(systemName: "exclamationmark.octagon.fill")
//                    .font(.avenirSubtitle)
//                    .foregroundColor(.Main.accentRed)
//                    .padding(.leading, 8)
//            }
//        }
    }
    
    private func infoMessageCell(_ message: ChatMessage) -> some View {
        HStack {
            Spacer()
            
            Text(message.text)
                .font(.avenirTagline)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Main.grey.opacity(0.3))
                }
            
            Spacer()
        }
    }
    
    private var newMesasgesCell: some View {
        HStack {
            
            Rectangle()
                .frame(height: 1)
            
            Text(String.Trip.chatNewMessages)
                .font(.avenirBody)
                .textCase(.uppercase)
                .padding(.vertical, 12)
                .fixedSize(horizontal: true, vertical: false)
            
            Rectangle()
                .frame(height: 1)
        }
    }
    
    private func chatMessageView(_ text: String) -> some View {
        Text(text)
            .font(.avenirBody)
    }
    
    @ViewBuilder
    private func authorNameView(_ authorName: String?) -> some View {
        if let authorName {
            Text(authorName)
                .font(.avenirTagline)
                .bold()
        }
    }
    
    @ViewBuilder
    private func authorImageView(_ url: URL?, isTitleCell: Bool) -> some View {
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
        .background(.thinMaterial)
    }
    
    private var textFieldInputView: some View {
        TextField("", text: $viewModel.chatMessageText, axis: .vertical)
            .font(.avenirBody)
            .foregroundColor(Color.Main.text)
            .tint(Color.Main.accentBlue)
            .lineLimit(5)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .focused($focusState, equals: .inputField)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.Chat.incomingBubble)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
    }

    private var sendButton: some View {
        Button {
            viewModel.sendChatMessage()
        } label: {
            Image(systemName: "paperplane.circle.fill")
                .foregroundStyle(Color.Main.strongWhite,
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
        TripChatView(title: "Trip Chat", viewModel: .init())
    }
}
