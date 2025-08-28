import SwiftUI

struct ChatListView: View {
    @Environment(\.appState) private var appState
    @Environment(\.interactors) private var interactors
    @State private var showingProfile = false
    @State private var selectedTab = "All"
    
    private var filteredChats: [Chat] {
        switch selectedTab {
        case "New Messages":
            return appState.chatState.chats.filter { chat in
                appState.chatState.hasUnreadMessages(for: chat)
            }
        case "Groups":
            // For now, assume no group chats - could be extended later
            return []
        default: // "All"
            return appState.chatState.chats
        }
    }
    
    var body: some View {
        ZStack {
            // Dark background like in screenshots
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header with user profile (like middle screenshot)
                ChatListHeaderView(
                    onProfileTap: { showingProfile = true },
                    selectedTab: $selectedTab
                )
                
                // Main content
                Group {
                    if appState.chatState.isLoading {
                        VStack(spacing: Theme.Spacing.md) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .accentColor(Theme.Colors.primary)
                            Text("Loading chats...")
                                .font(Theme.Typography.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = appState.chatState.error {
                        VStack(spacing: Theme.Spacing.md) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            
                            Text("Something went wrong")
                                .font(Theme.Typography.headline)
                                .foregroundColor(.white)
                            
                            Text(error.localizedDescription)
                                .font(Theme.Typography.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Button("Try Again") {
                                Task {
                                    await interactors.chatInteractor.loadChats()
                                }
                            }
                            .primaryButton()
                        }
                        .padding()
                    } else if appState.chatState.chats.isEmpty {
                        VStack(spacing: Theme.Spacing.md) {
                            Image(systemName: "message")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No conversations yet")
                                .font(Theme.Typography.headline)
                                .foregroundColor(.white)
                            
                            Text("Start a conversation to see it here")
                                .font(Theme.Typography.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: Theme.Spacing.md) {
                                ForEach(filteredChats, id: \.id) { chat in
                                    NavigationLink(destination: ChatScreenView(chat: chat)) {
                                        ModernChatRowView(chat: chat)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.top, Theme.Spacing.sm)
                        }
                        .refreshable {
                            await interactors.chatInteractor.loadChats()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingProfile) {
            UserProfileView()
        }
        .task {
            await interactors.chatInteractor.loadChats()
        }
    }
}

#Preview {
    NavigationStack {
        ChatListView()
    }
    .inject(AppContainer(
        appState: AppState(),
        interactors: .stub
    ))
}