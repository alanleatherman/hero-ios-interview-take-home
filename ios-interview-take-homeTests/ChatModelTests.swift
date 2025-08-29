import Testing
import Foundation
@testable import ios_interview_take_home

struct ChatModelTests {
    
    @Test func chatInitialization() {
        // Given
        let otherUserName = "TestUser"
        let messages = [
            Message(content: "Hello", isFromCurrentUser: false),
            Message(content: "Hi there", isFromCurrentUser: true)
        ]
        let profile = Profile(name: "TestUser", emoji: "😊", isOnline: true)
        
        // When
        let chat = Chat(otherUserName: otherUserName, messages: messages, profile: profile)
        
        // Then
        #expect(chat.otherUserName == otherUserName)
        #expect(chat.messages.count == 2)
        #expect(chat.profile?.name == "TestUser")
        #expect(chat.lastReadMessageId == nil)
    }
    
    @Test func sortedMessages() {
        // Given
        let oldMessage = Message(content: "Old", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600))
        let newMessage = Message(content: "New", isFromCurrentUser: true, timestamp: Date())
        let chat = Chat(otherUserName: "TestUser", messages: [newMessage, oldMessage])
        
        // When
        let sortedMessages = chat.sortedMessages
        
        // Then
        #expect(sortedMessages.count == 2)
        #expect(sortedMessages.first?.content == "Old")
        #expect(sortedMessages.last?.content == "New")
    }
    
    @Test func lastMessage() {
        // Given
        let oldMessage = Message(content: "Old", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600))
        let newMessage = Message(content: "New", isFromCurrentUser: true, timestamp: Date())
        let chat = Chat(otherUserName: "TestUser", messages: [oldMessage, newMessage])
        
        // When
        let lastMessage = chat.lastMessage
        
        // Then
        #expect(lastMessage != nil)
        #expect(lastMessage?.content == "New")
    }
    
    @Test func lastMessageWithEmptyMessages() {
        // Given
        let chat = Chat(otherUserName: "TestUser", messages: [])
        
        // When
        let lastMessage = chat.lastMessage
        
        // Then
        #expect(lastMessage == nil)
    }
    
    @Test func hasUnreadMessagesWithNoMessages() {
        // Given
        let chat = Chat(otherUserName: "TestUser", messages: [])
        
        // When
        let hasUnread = chat.hasUnreadMessages
        
        // Then
        #expect(hasUnread == false)
    }
    
    @Test func hasUnreadMessagesWithUserMessage() {
        // Given
        let userMessage = Message(content: "My message", isFromCurrentUser: true)
        let chat = Chat(otherUserName: "TestUser", messages: [userMessage])
        
        // When
        let hasUnread = chat.hasUnreadMessages
        
        // Then
        #expect(hasUnread == false) // User's own messages don't count as unread
    }
    
    @Test func hasUnreadMessagesWithOtherUserMessage() {
        // Given
        let otherMessage = Message(content: "Other's message", isFromCurrentUser: false)
        let chat = Chat(otherUserName: "TestUser", messages: [otherMessage])
        
        // When
        let hasUnread = chat.hasUnreadMessages
        
        // Then
        #expect(hasUnread == true) // Other user's message should be unread initially
    }
    
    @Test func markAsRead() {
        // Given
        let message = Message(content: "Test message", isFromCurrentUser: false)
        let chat = Chat(otherUserName: "TestUser", messages: [message])
        
        // When
        chat.markAsRead()
        
        // Then
        #expect(chat.lastReadMessageId == message.id)
        #expect(chat.hasUnreadMessages == false)
    }
    
    @Test func markAsReadWithMultipleMessages() {
        // Given
        let oldMessage = Message(content: "Old", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600))
        let newMessage = Message(content: "New", isFromCurrentUser: false, timestamp: Date())
        let chat = Chat(otherUserName: "TestUser", messages: [oldMessage, newMessage])
        
        // When
        chat.markAsRead()
        
        // Then
        #expect(chat.lastReadMessageId == newMessage.id) // Should mark the latest message as read
        #expect(chat.hasUnreadMessages == false)
    }
    
    @Test func hasUnreadAfterPartialRead() {
        // Given
        let oldMessage = Message(content: "Old", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600))
        let newMessage = Message(content: "New", isFromCurrentUser: false, timestamp: Date())
        let chat = Chat(otherUserName: "TestUser", messages: [oldMessage])
        
        // Mark first message as read
        chat.markAsRead()
        
        // Add new message
        chat.messages.append(newMessage)
        
        // When
        let hasUnread = chat.hasUnreadMessages
        
        // Then
        #expect(hasUnread == true) // Should have unread messages after new message arrives
    }
}