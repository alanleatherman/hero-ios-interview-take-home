import Foundation
import SwiftData

@Model
final class Chat {
    var id: UUID
    var otherUserName: String
    
    // SwiftData relationships
    @Relationship(deleteRule: .cascade, inverse: \Message.chat)
    var messages: [Message] = []
    
    @Relationship(deleteRule: .nullify)
    var profile: Profile?
    
    init(id: UUID = UUID(), otherUserName: String, messages: [Message] = [], profile: Profile? = nil) {
        self.id = id
        self.otherUserName = otherUserName
        self.messages = messages
        self.profile = profile
    }
}

// MARK: - Backward Compatibility
// Maintain existing convenience initializers for compatibility
extension Chat {
    convenience init(otherUserName: String, messages: [Message]) {
        self.init(id: UUID(), otherUserName: otherUserName, messages: messages)
    }
}

// MARK: - Sample Data
extension Chat {
    static let sample = Chat(
        otherUserName: "Alice",
        messages: [
            Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
            Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-1800))
        ]
    )
    
    static let samples = [
        Chat(
            otherUserName: "Alice",
            messages: [
                Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
                Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-1800))
            ]
        ),
        Chat(
            otherUserName: "Bob",
            messages: [
                Message(content: "Did you finish the project?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-7200)),
                Message(content: "Almost done, should be ready tomorrow", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600))
            ]
        ),
        Chat(
            otherUserName: "Charlie",
            messages: [
                Message(content: "Want to grab lunch later?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-1800))
            ]
        )
    ]
} 
