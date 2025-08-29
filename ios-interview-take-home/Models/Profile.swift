import Foundation
import SwiftData

@Model
final class Profile {
    var id: UUID
    var name: String
    var emoji: String
    var isOnline: Bool // Fake status for UI purposes
    
    init(id: UUID = UUID(), name: String, emoji: String, isOnline: Bool = true) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isOnline = isOnline
    }
}

// MARK: - Sample Data

extension Profile {
    static let samples = [
        Profile(name: "Alice", emoji: "😊", isOnline: true),
        Profile(name: "Bob", emoji: "🤔", isOnline: false),
        Profile(name: "Charlie", emoji: "😎", isOnline: true),
        Profile(name: "Diana", emoji: "🌟", isOnline: true)
    ]
    
    static let sampleAlice = Profile(name: "Alice", emoji: "😊", isOnline: true)
    static let sampleBob = Profile(name: "Bob", emoji: "🤔", isOnline: false)
}
