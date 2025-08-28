import Foundation
import SwiftUI

// MARK: - App State

@Observable
class AppState {
    var chatState = ChatState()
}

// MARK: - Chat State

@Observable 
class ChatState {
    var chats: [Chat] = []
    var isLoading = false
    var error: Error?
    var selectedChat: Chat?
    
    // Helper computed properties
    var hasError: Bool {
        error != nil
    }
    
    var isEmpty: Bool {
        chats.isEmpty && !isLoading
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
    }
    
    func clearSelection() {
        selectedChat = nil
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
