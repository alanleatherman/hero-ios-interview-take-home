import Foundation

// MARK: - Chat Interactor

@MainActor
@Observable
class ChatInteractor: ChatInteractorProtocol {
    private let repository: ChatRepositoryProtocol
    private let appState: AppState
    
    init(repository: ChatRepositoryProtocol, appState: AppState) {
        self.repository = repository
        self.appState = appState
    }
    
    // MARK: - ChatInteractorProtocol Implementation
    
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
    
    func sendMessage(_ content: String, to otherUserName: String) async {
        do {
            // Send the message through the repository (this handles persistence)
            _ = try await repository.sendMessage(content, to: otherUserName)
            
            // Reload chats to get the updated state with both messages
            await loadChats()
            
        } catch {
            appState.chatState.setError(error)
            print("Failed to send message: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Additional Helper Methods
    
    func refreshChats() async {
        await loadChats()
    }
    
    func clearError() {
        appState.chatState.clearError()
    }
    
    func markChatAsRead(_ chat: Chat) async {
        // Mark the chat as read
        chat.markAsRead()
        
        // Persist the change
        do {
            try await repository.saveChat(chat)
        } catch {
            print("Failed to save chat read status: \(error.localizedDescription)")
        }
    }
    
    nonisolated func getChat(with otherUserName: String) async -> Chat? {
        do {
            return try await repository.getChat(with: otherUserName)
        } catch {
            print("Failed to get chat for \(otherUserName): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    
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
    func markChatAsRead(_ chat: Chat) async {}
}
