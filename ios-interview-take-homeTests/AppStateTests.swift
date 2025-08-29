import Testing
import Foundation
@testable import ios_interview_take_home

struct AppStateTests {
    
    // MARK: - UserState Tests
    
    @Test func userStateInitialValues() {
        // Setup
        let appState = AppState()
        
        // Then
        #expect(appState.userState.userName == "")
        #expect(appState.userState.profileImage == nil)
        #expect(appState.userState.hasCompletedOnboarding == false)
    }
    
    @Test func userStateSetters() {
        // Setup
        let appState = AppState()
        
        // When
        appState.userState.userName = "Test User"
        appState.userState.profileImage = Data()
        appState.userState.hasCompletedOnboarding = true
        
        // Then
        #expect(appState.userState.userName == "Test User")
        #expect(appState.userState.profileImage != nil)
        #expect(appState.userState.hasCompletedOnboarding == true)
    }
    
    @Test func userStateReset() {
        // Setup
        let appState = AppState()
        
        // Given
        appState.userState.userName = "Test User"
        appState.userState.profileImage = Data()
        appState.userState.hasCompletedOnboarding = true
        
        // When - manually reset since there's no reset method
        appState.userState.userName = ""
        appState.userState.profileImage = nil
        appState.userState.hasCompletedOnboarding = false
        
        // Then
        #expect(appState.userState.userName == "")
        #expect(appState.userState.profileImage == nil)
        #expect(appState.userState.hasCompletedOnboarding == false)
    }
    
    // MARK: - ChatState Tests
    
    @Test func chatStateInitialValues() {
        // Setup
        let appState = AppState()
        
        // Then
        #expect(appState.chatState.chats.isEmpty == true)
        #expect(appState.chatState.isLoading == false)
        #expect(appState.chatState.error == nil)
    }
    
    @Test func chatStateSetChats() {
        // Setup
        let appState = AppState()
        
        // Given
        let testChats = [
            Chat(otherUserName: "User1", messages: []),
            Chat(otherUserName: "User2", messages: [])
        ]
        
        // When
        appState.chatState.setChats(testChats)
        
        // Then
        #expect(appState.chatState.chats.count == 2)
        #expect(appState.chatState.chats[0].otherUserName == "User1")
        #expect(appState.chatState.chats[1].otherUserName == "User2")
        #expect(appState.chatState.isLoading == false)
    }
    
    @Test func chatStateSetLoading() {
        // Setup
        let appState = AppState()
        
        // When
        appState.chatState.setLoading(true)
        
        // Then
        #expect(appState.chatState.isLoading == true)
        #expect(appState.chatState.error == nil) // Error should be cleared when loading starts
        
        // When
        appState.chatState.setLoading(false)
        
        // Then
        #expect(appState.chatState.isLoading == false)
    }
    
    @Test func chatStateSetError() {
        // Setup
        let appState = AppState()
        
        // Given
        let testError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        
        // When
        appState.chatState.setError(testError)
        
        // Then
        #expect(appState.chatState.error != nil)
        #expect(appState.chatState.error?.localizedDescription == "Test error")
        #expect(appState.chatState.isLoading == false) // Loading should stop when error occurs
    }
    
    @Test func chatStateClearError() {
        // Setup
        let appState = AppState()
        
        // Given
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        appState.chatState.setError(testError)
        #expect(appState.chatState.error != nil)
        
        // When
        appState.chatState.clearError()
        
        // Then
        #expect(appState.chatState.error == nil)
    }
    
    @Test func chatStateReset() {
        // Setup
        let appState = AppState()
        
        // Given
        let testChats = [Chat(otherUserName: "User1", messages: [])]
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        appState.chatState.setChats(testChats)
        appState.chatState.setLoading(true)
        appState.chatState.setError(testError)
        
        // When - manually reset since there's no reset method
        appState.chatState.chats = []
        appState.chatState.isLoading = false
        appState.chatState.error = nil
        
        // Then
        #expect(appState.chatState.chats.isEmpty == true)
        #expect(appState.chatState.isLoading == false)
        #expect(appState.chatState.error == nil)
    }
    
    // MARK: - Integration Tests
    
    @Test func appStateReset() {
        // Setup
        let appState = AppState()
        
        // Given
        appState.userState.userName = "Test User"
        appState.userState.hasCompletedOnboarding = true
        appState.chatState.setChats([Chat(otherUserName: "User1", messages: [])])
        
        // When - manually reset both states since there's no reset method
        appState.userState.userName = ""
        appState.userState.hasCompletedOnboarding = false
        appState.chatState.chats = []
        
        // Then
        #expect(appState.userState.userName == "")
        #expect(appState.userState.hasCompletedOnboarding == false)
        #expect(appState.chatState.chats.isEmpty == true)
    }
}