import SwiftUI

struct ChatListView: View {
    @Environment(\.appState) private var appState
    @Environment(\.interactors) private var interactors
    
    var body: some View {
        Group {
            if appState.chatState.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading chats...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            } else if let error = appState.chatState.error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text("Something went wrong")
                        .font(.headline)
                    
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Try Again") {
                        Task {
                            await interactors.chatInteractor.loadChats()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if appState.chatState.chats.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "message")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("No conversations yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Start a conversation to see it here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else {
                List {
                    ForEach(appState.chatState.chats, id: \.id) { chat in
                        NavigationLink(destination: ChatScreenView(chat: chat)) {
                            ChatRowView(chat: chat)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await interactors.chatInteractor.loadChats()
                }
            }
        }
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.large)
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