import Foundation

// MARK: - Chat Interactor

@Observable
class ChatInteractor: ChatInteractorProtocol {
    private let repository: ChatRepositoryProtocol
    private let appState: AppState
    
    init(repository: ChatRepositoryProtocol, appState: AppState) {
        self.repository = repository
        self.appState = appState
    }
    
    // MARK: - ChatInteractorProtocol Implementation
    
    @MainActor
    func loadChats() async {
        appState.chatState.setLoading(true)
        
        do {
            let chats = try await repository.getAllChats()
            appState.chatState.setChats(chats)
        } catch {
            appState.chatState.setError(error)
            
            // Log error for debugging
            print("Failed to load chats: \(error.localizedDescription)")
            
            // Attempt to load cached data as fallback
            await loadCachedChatsAsFallback()
        }
    }
    
    @MainActor
    func sendMessage(_ content: String, to otherUserName: String) async {
        // Optimistically add the message to the UI
        let optimisticMessage = Message(
            content: content,
            isFromCurrentUser: true,
            timestamp: Date()
        )
        
        // Find the chat and add the message optimistically
        if let chatIndex = appState.chatState.chats.firstIndex(where: { $0.otherUserName == otherUserName }) {
            appState.chatState.chats[chatIndex].messages.append(optimisticMessage)
        }
        
        do {
            // Send the message through the repository
            let responseMessage = try await repository.sendMessage(content, to: otherUserName)
            
            // Add the response message if we got one
            if let chatIndex = appState.chatState.chats.firstIndex(where: { $0.otherUserName == otherUserName }) {
                appState.chatState.chats[chatIndex].messages.append(responseMessage)
            }
            
        } catch {
            // Remove the optimistic message on failure
            if let chatIndex = appState.chatState.chats.firstIndex(where: { $0.otherUserName == otherUserName }) {
                appState.chatState.chats[chatIndex].messages.removeAll { message in
                    message.content == content && 
                    message.isFromCurrentUser && 
                    abs(message.timestamp.timeIntervalSince(optimisticMessage.timestamp)) < 1.0
                }
            }
            
            appState.chatState.setError(error)
            print("Failed to send message: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Additional Helper Methods
    
    @MainActor
    func refreshChats() async {
        await loadChats()
    }
    
    @MainActor
    func clearError() {
        appState.chatState.clearError()
    }
    
    func getChat(with otherUserName: String) async -> Chat? {
        do {
            return try await repository.getChat(with: otherUserName)
        } catch {
            print("Failed to get chat for \(otherUserName): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func loadCachedChatsAsFallback() async {
        do {
            let cachedChats = try await repository.loadCachedChats()
            if !cachedChats.isEmpty {
                appState.chatState.setChats(cachedChats)
                print("Loaded cached chats as fallback")
            }
        } catch {
            print("Failed to load cached chats: \(error.localizedDescription)")
            // If all else fails, keep the error state but don't crash
        }
    }
}

// MARK: - Stub

class StubChatInteractor: ChatInteractorProtocol {
    func loadChats() async {}
    func sendMessage(_ content: String, to otherUserName: String) async {}
}
