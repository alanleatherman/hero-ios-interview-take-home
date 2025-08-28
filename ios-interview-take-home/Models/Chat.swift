import Foundation
import SwiftData

@Model
final class Chat {
    var id: UUID
    var otherUserName: String
    var lastReadMessageId: UUID? // Track the last message the user has read
    
    // SwiftData relationships
    @Relationship(deleteRule: .cascade, inverse: \Message.chat)
    var messages: [Message] = []
    
    @Relationship(deleteRule: .nullify)
    var profile: Profile?
    
    init(id: UUID = UUID(), otherUserName: String, messages: [Message] = [], profile: Profile? = nil, lastReadMessageId: UUID? = nil) {
        self.id = id
        self.otherUserName = otherUserName
        self.messages = messages
        self.profile = profile
        self.lastReadMessageId = lastReadMessageId
    }
    
    // Computed property to get messages sorted by timestamp (oldest first)
    var sortedMessages: [Message] {
        messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    // Computed property to get the last message (most recent)
    var lastMessage: Message? {
        messages.max { $0.timestamp < $1.timestamp }
    }
    
    // Computed property to check if there are unread messages
    var hasUnreadMessages: Bool {
        guard let lastMessage = lastMessage,
              !lastMessage.isFromCurrentUser else {
            return false // No messages or last message is from current user
        }
        
        // If we haven't read any messages, or the last message is newer than what we've read
        return lastReadMessageId == nil || lastReadMessageId != lastMessage.id
    }
    
    // Method to mark chat as read up to the latest message
    func markAsRead() {
        if let lastMessage = lastMessage {
            lastReadMessageId = lastMessage.id
        }
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
        ],
        profile: Profile(name: "Alice", emoji: "😊", isOnline: true)
    )
    
    static let samples = [
        Chat(
            otherUserName: "Alice",
            messages: [
                Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
                Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-1800))
            ],
            profile: Profile(name: "Alice", emoji: "😊", isOnline: true)
        ),
        Chat(
            otherUserName: "Bob",
            messages: [
                Message(content: "Did you finish the project?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-7200)),
                Message(content: "Almost done, should be ready tomorrow", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600))
            ],
            profile: Profile(name: "Bob", emoji: "🤔", isOnline: false)
        ),
        Chat(
            otherUserName: "Charlie",
            messages: [
                Message(content: "Want to grab lunch later?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-1800))
            ],
            profile: Profile(name: "Charlie", emoji: "😎", isOnline: true)
        )
    ]
} 
