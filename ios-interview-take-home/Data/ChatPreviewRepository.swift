import Foundation

class ChatPreviewRepository: ChatRepositoryProtocol {
    private var mockChats: [Chat] = []
    
    init() {
        setupMockData()
    }
    
    // MARK: - ChatRepositoryProtocol Implementation
    
    func getAllChats() async throws -> [Chat] {
        // Simulate slight delay for realistic preview behavior
        try? await Task.sleep(for: .milliseconds(100))
        return mockChats
    }
    
    func getChat(with otherUserName: String) async throws -> Chat? {
        return mockChats.first { $0.otherUserName == otherUserName }
    }
    
    func sendMessage(_ content: String, to otherUserName: String) async throws -> Message {
        // Create the user's message
        let message = Message(content: content, isFromCurrentUser: true, timestamp: Date())
        
        // Find or create chat
        var chat = mockChats.first { $0.otherUserName == otherUserName }
        if chat == nil {
            let profile = Profile(name: otherUserName, emoji: getRandomEmoji(), isOnline: true)
            chat = Chat(otherUserName: otherUserName, messages: [], profile: profile)
            mockChats.append(chat!)
        }
        
        // Add user message
        chat?.messages.append(message)
        
        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(500))
        
        // Create fake response
        let fakeResponse = getFakeResponse(for: content)
        let responseMessage = Message(content: fakeResponse, isFromCurrentUser: false, timestamp: Date())
        
        // Add response message
        chat?.messages.append(responseMessage)
        
        return responseMessage
    }
    
    func loadCachedChats() async throws -> [Chat] {
        return mockChats
    }
    
    func saveChat(_ chat: Chat) async throws {
        // For preview repository, just update in-memory storage
        if let index = mockChats.firstIndex(where: { $0.otherUserName == chat.otherUserName }) {
            mockChats[index] = chat
        } else {
            mockChats.append(chat)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupMockData() {
        let now = Date()
        
        let sampleData = [
            ("Alice", "😊", [
                Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-3600)),
                Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-1800)),
                Message(content: "That's great to hear! Any exciting plans for the weekend?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-900))
            ]),
            ("Bob", "🤔", [
                Message(content: "Did you finish the project?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-7200)),
                Message(content: "Almost done, should be ready tomorrow", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-3600)),
                Message(content: "Awesome! Let me know when it's ready for review", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-1800))
            ]),
            ("Charlie", "😎", [
                Message(content: "Want to grab lunch later?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-1800)),
                Message(content: "Sure! What time works for you?", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-900))
            ]),
            ("Diana", "🌟", [
                Message(content: "The meeting is scheduled for 3 PM", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-900)),
                Message(content: "Perfect, I'll be there", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-300)),
                Message(content: "Great! See you then", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-60))
            ])
        ]
        
        mockChats = sampleData.map { (name, emoji, messages) in
            let profile = Profile(name: name, emoji: emoji, isOnline: Bool.random())
            return Chat(otherUserName: name, messages: messages, profile: profile)
        }
    }
    
    private func getFakeResponse(for message: String) -> String {
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
            "I appreciate you reaching out.",
            "Absolutely! I agree with that.",
            "Hmm, let me think about it.",
            "You make a good point there.",
            "I hadn't considered that before."
        ]
        
        return responses.randomElement() ?? "Thanks for the message!"
    }
    
    private func getRandomEmoji() -> String {
        let emojis = ["😊", "🤔", "😎", "🌟", "🚀", "💡", "🎉", "🔥", "⭐", "🌈"]
        return emojis.randomElement() ?? "😊"
    }
}