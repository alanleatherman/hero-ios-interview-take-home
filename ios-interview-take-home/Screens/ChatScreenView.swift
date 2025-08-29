import SwiftUI

struct ChatScreenView: View {
    @Environment(\.interactors) private var interactors
    @Environment(\.appState) private var appState
    @Environment(\.dismiss) private var dismiss
    
    @State private var messageText = ""
    @State private var showingProfile = false
    
    let chat: Chat
    
    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(
                chat: chat,
                onBackTap: { dismiss() },
                onProfileTap: { showingProfile = true }
            )
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: Theme.Spacing.sm) {
                            ForEach(chat.sortedMessages, id: \.id) { message in
                                MessageBubbleView(message: message)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(Theme.Animation.standard, value: chat.messages.count)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                    }
                    .onAppear {
                        if let lastMessage = chat.lastMessage {
                            DispatchQueue.main.async {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: chat.messages.count) { _, _ in
                        if let lastMessage = chat.lastMessage {
                            withAnimation(Theme.Animation.standard) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            ModernInputBarView(
                text: $messageText,
                onSend: {
                    let messageToSend = messageText
                    messageText = ""
                    
                    Task {
                        await interactors.chatInteractor.sendMessage(messageToSend, to: chat.otherUserName)
                    }
                }
            )
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingProfile) {
            ProfileDetailView(chat: chat)
        }
        .onAppear {
            Task {
                await interactors.chatInteractor.markChatAsRead(chat)
            }
        }
        .onChange(of: chat.messages.count) { _, _ in
            Task {
                await interactors.chatInteractor.markChatAsRead(chat)
            }
        }
    }
}

#Preview {
    let sampleChat = Chat(
        otherUserName: "Keisya",
        messages: [
            Message(content: "Good morning! How are you today?", isFromCurrentUser: false),
            Message(content: "Hey! I'm doing great, thanks for asking 😊", isFromCurrentUser: true),
            Message(content: "That's wonderful to hear! Any plans for the weekend?", isFromCurrentUser: false)
        ],
        profile: Profile(name: "Keisya", emoji: "👩🏻‍💼", isOnline: true)
    )
    
    return NavigationStack {
        ChatScreenView(chat: sampleChat)
    }
    .inject(AppContainer(
        appState: AppState(),
        interactors: .stub
    ))
}
