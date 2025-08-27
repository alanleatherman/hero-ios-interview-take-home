import Foundation

struct Message {
    let id: UUID = UUID()
    let content: String
    let isFromCurrentUser: Bool
    let timestamp: Date
} 
