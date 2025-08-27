import Foundation

class ChatRepository {
    private(set) var chats: [String: Chat] = [:]
    
    // Sample data for the interview
    init() {
        setupSampleData()
    }
    
    // MARK: - Public Methods
    
    /// Get all chats
    func getAllChats() -> [Chat] {
        Array(chats.values)
    }
    
    /// Send a message to a specific user
    func sendMessage(_ content: String, to otherUserName: String) async -> Message {
        let message = Message(content: content, isFromCurrentUser: true, timestamp: Date())
        addMessage(message, to: otherUserName)
        
        // Simulate network delay
        try? await Task.sleep(for: .seconds(1))
        
        // Get fake response
        let fakeResponse = await getFakeResponse(for: content)
        let responseMessage = Message(content: fakeResponse, isFromCurrentUser: false, timestamp: Date())
        addMessage(responseMessage, to: otherUserName)
        
        return responseMessage
    }
    
    // MARK: - Private Methods
    
    private func addMessage(_ message: Message, to otherUserName: String) {
        if chats[otherUserName] == nil {
            chats[otherUserName] = Chat(otherUserName: otherUserName, messages: [])
        }
        chats[otherUserName]?.messages.append(message)
    }
    
    private func getFakeResponse(for message: String) async -> String {
        // Simulate network delay for response
        try? await Task.sleep(for: .seconds(1))
        
        let responses = [
            "That's interesting! Tell me more.",
            "I see what you mean.",
            "Thanks for sharing that with me.",
            "I'm not sure I understand. Could you clarify?",
            "That sounds great!",
            "I'll think about that.",
            "Thanks for the message!",
            "Got it!",
            "Interesting perspective.",
            "I appreciate you reaching out."
        ]
        
        return responses.randomElement() ?? "Thanks for the message!"
    }
    
    private func setupSampleData() {
        let now = Date()
        
        // Create some sample chats with initial messages
        let sampleChats = [
            "Alice": [
                Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-3600)),
                Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-1800))
            ],
            "Bob": [
                Message(content: "Did you finish the project?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-7200)),
                Message(content: "Almost done, should be ready tomorrow", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600))
            ],
            "Charlie": [
                Message(content: "Want to grab lunch later?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-1800))
            ],
            "Diana": [
                Message(content: "The meeting is scheduled for 3 PM", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-900)),
                Message(content: "Perfect, I'll be there", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-300))
            ]
        ]
        
        for (userName, messages) in sampleChats {
            chats[userName] = Chat(otherUserName: userName, messages: messages)
        }
    }
} 
