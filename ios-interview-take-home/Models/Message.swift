import Foundation
import SwiftData

@Model
final class Message {
    var id: UUID
    var content: String
    var isFromCurrentUser: Bool
    var timestamp: Date
    
    // SwiftData relationship
    var chat: Chat?
    
    init(id: UUID = UUID(), content: String, isFromCurrentUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isFromCurrentUser = isFromCurrentUser
        self.timestamp = timestamp
    }
}

// MARK: - Backward Compatibility
// Maintain existing convenience initializers for compatibility
extension Message {
    convenience init(content: String, isFromCurrentUser: Bool, timestamp: Date) {
        self.init(id: UUID(), content: content, isFromCurrentUser: isFromCurrentUser, timestamp: timestamp)
    }
}

// MARK: - Sample Data
extension Message {
    static let sampleSent = Message(
        content: "Hey! How's it going?",
        isFromCurrentUser: true,
        timestamp: Date().addingTimeInterval(-3600)
    )
    
    static let sampleReceived = Message(
        content: "Pretty good, thanks for asking!",
        isFromCurrentUser: false,
        timestamp: Date().addingTimeInterval(-1800)
    )
    
    static let samples = [
        Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
        Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-1800)),
        Message(content: "Want to grab lunch later?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-900)),
        Message(content: "Sure! What time works for you?", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-300))
    ]
} 
