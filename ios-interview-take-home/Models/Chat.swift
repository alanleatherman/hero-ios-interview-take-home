import Foundation

struct Chat {
    let id: UUID = UUID()
    let otherUserName: String
    var messages: [Message]
} 
