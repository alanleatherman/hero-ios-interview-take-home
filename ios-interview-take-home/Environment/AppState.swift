import Foundation
import SwiftUI

// MARK: - App State

@Observable
class AppState {
    var chatState = ChatState()
    var userState = UserState()
}

// MARK: - Chat State

@Observable 
class ChatState {
    var chats: [Chat] = []
    var isLoading = false
    var error: Error?
    var selectedChat: Chat?
    var viewedChats: Set<UUID> = [] // Track which chats have been viewed
    
    // Helper computed properties
    var hasError: Bool {
        error != nil
    }
    
    var isEmpty: Bool {
        chats.isEmpty && !isLoading
    }
    
    var totalUnreadCount: Int {
        chats.reduce(0) { total, chat in
            total + (hasUnreadMessages(for: chat) ? 1 : 0)
        }
    }
    
    // Methods for state management
    func clearError() {
        error = nil
    }
    
    func setLoading(_ loading: Bool) {
        isLoading = loading
        if loading {
            error = nil
        }
    }
    
    func setChats(_ newChats: [Chat]) {
        chats = newChats
        isLoading = false
        error = nil
    }
    
    func setError(_ newError: Error) {
        error = newError
        isLoading = false
    }
    
    func selectChat(_ chat: Chat) {
        selectedChat = chat
        markChatAsViewed(chat)
    }
    
    func clearSelection() {
        selectedChat = nil
    }
    
    func markChatAsViewed(_ chat: Chat) {
        viewedChats.insert(chat.id)
    }
    
    func hasUnreadMessages(for chat: Chat) -> Bool {
        // Check if chat has messages and hasn't been viewed
        guard let lastMessage = chat.messages.last,
              !lastMessage.isFromCurrentUser else {
            return false
        }
        return !viewedChats.contains(chat.id)
    }
}

// MARK: - User State

@Observable
class UserState {
    var userName: String = "User"
    var profileImage: Data?
    var hasCompletedOnboarding: Bool = false
    var hasShownTypewriter: Bool = false
    
    func updateUserName(_ name: String) {
        userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func updateProfileImage(_ imageData: Data?) {
        profileImage = imageData
    }
    
    func completeOnboarding(name: String, profileImage: Data?) {
        updateUserName(name)
        updateProfileImage(profileImage)
        hasCompletedOnboarding = true
    }
    
    func markTypewriterShown() {
        hasShownTypewriter = true
    }
}

// MARK: - Sample States for Previews

extension AppState {
    static let sample: AppState = {
        let state = AppState()
        state.chatState.chats = Chat.samples
        return state
    }()
    
    static let loading: AppState = {
        let state = AppState()
        state.chatState.isLoading = true
        return state
    }()
    
    static let empty: AppState = {
        let state = AppState()
        state.chatState.chats = []
        return state
    }()
    
    static let error: AppState = {
        let state = AppState()
        state.chatState.error = ChatError.networkSimulationFailure
        return state
    }()
}
