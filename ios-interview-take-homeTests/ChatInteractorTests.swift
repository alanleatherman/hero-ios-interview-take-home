import Testing
import Foundation
@testable import ios_interview_take_home

@MainActor
struct ChatInteractorTests {
    
    @Test func loadChatsSuccess() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        let testChat = Chat(otherUserName: "TestUser", messages: [])
        mockRepository.chats = [testChat]
        
        // When
        await chatInteractor.loadChats()
        
        // Then
        #expect(appState.chatState.chats.count == 1)
        #expect(appState.chatState.chats.first?.otherUserName == "TestUser")
        #expect(appState.chatState.isLoading == false)
        #expect(appState.chatState.error == nil)
    }
    
    @Test func loadChatsFailure() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        await chatInteractor.loadChats()
        
        // Then
        #expect(appState.chatState.error != nil)
        #expect(appState.chatState.isLoading == false)
    }
    
    @Test func sendMessageSuccess() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        let content = "Test message"
        let otherUserName = "TestUser"
        
        // When
        await chatInteractor.sendMessage(content, to: otherUserName)
        
        // Then
        #expect(mockRepository.chats.count == 1)
        #expect(mockRepository.chats.first?.otherUserName == otherUserName)
        #expect(mockRepository.chats.first?.messages.count == 1)
        #expect(mockRepository.chats.first?.messages.first?.content == content)
    }
    
    @Test func sendMessageFailure() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        mockRepository.shouldThrowError = true
        let content = "Test message"
        let otherUserName = "TestUser"
        
        // When
        await chatInteractor.sendMessage(content, to: otherUserName)
        
        // Then
        #expect(appState.chatState.error != nil)
    }
    
    @Test func markChatAsRead() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        let message = Message(content: "Test", isFromCurrentUser: false)
        let chat = Chat(otherUserName: "TestUser", messages: [message])
        
        // When
        await chatInteractor.markChatAsRead(chat)
        
        // Then
        #expect(chat.lastReadMessageId == message.id)
        #expect(chat.hasUnreadMessages == false)
    }
    
    @Test func getChatSuccess() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        let testChat = Chat(otherUserName: "TestUser", messages: [])
        mockRepository.chats = [testChat]
        
        // When
        let result = await chatInteractor.getChat(with: "TestUser")
        
        // Then
        #expect(result != nil)
        #expect(result?.otherUserName == "TestUser")
    }
    
    @Test func getChatNotFound() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        mockRepository.chats = []
        
        // When
        let result = await chatInteractor.getChat(with: "NonExistentUser")
        
        // Then
        #expect(result == nil)
    }
    
    @Test func getChatFailure() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        let result = await chatInteractor.getChat(with: "TestUser")
        
        // Then
        #expect(result == nil)
    }
    
    @Test func refreshChats() async {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        let testChat = Chat(otherUserName: "TestUser", messages: [])
        mockRepository.chats = [testChat]
        
        // When
        await chatInteractor.refreshChats()
        
        // Then
        #expect(appState.chatState.chats.count == 1)
        #expect(appState.chatState.isLoading == false)
    }
    
    @Test func clearError() {
        // Setup
        let mockRepository = MockChatRepository()
        let appState = AppState()
        let chatInteractor = ChatInteractor(repository: mockRepository, appState: appState)
        
        // Given
        appState.chatState.setError(NSError(domain: "Test", code: 1, userInfo: nil))
        #expect(appState.chatState.error != nil)
        
        // When
        chatInteractor.clearError()
        
        // Then
        #expect(appState.chatState.error == nil)
    }
}