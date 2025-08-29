import Testing
import Foundation
@testable import ios_interview_take_home

struct MessageModelTests {
    
    @Test func messageInitialization() {
        // Given
        let content = "Test message"
        let isFromCurrentUser = true
        let timestamp = Date()
        
        // When
        let message = Message(content: content, isFromCurrentUser: isFromCurrentUser, timestamp: timestamp)
        
        // Then
        #expect(message.id != nil)
        #expect(message.content == content)
        #expect(message.isFromCurrentUser == isFromCurrentUser)
        #expect(message.timestamp == timestamp)
        #expect(message.chat == nil)
    }
    
    @Test func messageDefaultTimestamp() {
        // Given
        let content = "Test message"
        let isFromCurrentUser = false
        let beforeCreation = Date()
        
        // When
        let message = Message(content: content, isFromCurrentUser: isFromCurrentUser)
        let afterCreation = Date()
        
        // Then
        #expect(message.timestamp >= beforeCreation)
        #expect(message.timestamp <= afterCreation)
    }
    
    @Test func messageUniqueIds() {
        // Given & When
        let message1 = Message(content: "Message 1", isFromCurrentUser: true)
        let message2 = Message(content: "Message 2", isFromCurrentUser: false)
        
        // Then
        #expect(message1.id != message2.id)
    }
    
    @Test func convenienceInitializer() {
        // Given
        let content = "Test message"
        let isFromCurrentUser = true
        let timestamp = Date()
        
        // When
        let message = Message(content: content, isFromCurrentUser: isFromCurrentUser, timestamp: timestamp)
        
        // Then
        #expect(message.content == content)
        #expect(message.isFromCurrentUser == isFromCurrentUser)
        #expect(message.timestamp == timestamp)
    }
    
    @Test func sampleData() {
        // When
        let sampleSent = Message.sampleSent
        let sampleReceived = Message.sampleReceived
        let samples = Message.samples
        
        // Then
        #expect(sampleSent.isFromCurrentUser == true)
        #expect(sampleReceived.isFromCurrentUser == false)
        #expect(samples.count == 4)
        #expect(samples.isEmpty == false)
    }
}