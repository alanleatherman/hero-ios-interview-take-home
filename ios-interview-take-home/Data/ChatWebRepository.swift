import Foundation
import SwiftData

class ChatWebRepository: ChatRepositoryProtocol {
    private var modelContext: ModelContext?
    private var chats: [String: Chat] = [:]
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    // MARK: - ChatRepositoryProtocol Implementation
    
    func getAllChats() async throws -> [Chat] {
        do {
            if let modelContext = modelContext {
                // Load from SwiftData
                let descriptor = FetchDescriptor<Chat>()
                let persistedChats = try modelContext.fetch(descriptor)
                
                if persistedChats.isEmpty {
                    // If no persisted data, setup sample data
                    let sampleChats = createSampleChats()
                    for chat in sampleChats {
                        modelContext.insert(chat)
                    }
                    try modelContext.save()
                    return sampleChats
                }
                
                return persistedChats
            } else {
                // Fallback to in-memory storage
                if chats.isEmpty {
                    setupSampleData()
                }
                return Array(chats.values)
            }
        } catch {
            throw ChatError.persistenceFailure(error)
        }
    }
    
    func getChat(with otherUserName: String) async throws -> Chat? {
        let allChats = try await getAllChats()
        return allChats.first { $0.otherUserName == otherUserName }
    }
    
    func sendMessage(_ content: String, to otherUserName: String) async throws -> Message {
        do {
            let now = Date()
            
            // Create the user's message with current timestamp
            let message = Message(content: content, isFromCurrentUser: true, timestamp: now)
            
            // Add message to chat
            try await addMessage(message, to: otherUserName)
            
            // Simulate network delay
            try? await Task.sleep(for: .seconds(1))
            
            // Get fake response
            let fakeResponse = await getFakeResponse(for: content)
            // Ensure response message has a later timestamp
            let responseMessage = Message(content: fakeResponse, isFromCurrentUser: false, timestamp: now.addingTimeInterval(2))
            
            // Add response message
            try await addMessage(responseMessage, to: otherUserName)
            
            return responseMessage
        } catch {
            throw ChatError.networkSimulationFailure
        }
    }
    
    func loadCachedChats() async throws -> [Chat] {
        return try await getAllChats()
    }
    
    func saveChat(_ chat: Chat) async throws {
        guard let modelContext = modelContext else {
            // Fallback to in-memory storage
            chats[chat.otherUserName] = chat
            return
        }
        
        do {
            modelContext.insert(chat)
            try modelContext.save()
        } catch {
            throw ChatError.persistenceFailure(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func addMessage(_ message: Message, to otherUserName: String) async throws {
        if let modelContext = modelContext {
            // SwiftData persistence
            let descriptor = FetchDescriptor<Chat>(predicate: #Predicate<Chat> { chat in
                chat.otherUserName == otherUserName
            })
            
            let existingChats = try modelContext.fetch(descriptor)
            let chat: Chat
            
            if let existingChat = existingChats.first {
                // Use existing chat
                chat = existingChat
            } else {
                // Create new chat if it doesn't exist
                let profile = Profile(name: otherUserName, emoji: getRandomEmoji(), isOnline: Bool.random())
                chat = Chat(otherUserName: otherUserName, messages: [], profile: profile)
                
                modelContext.insert(profile)
                modelContext.insert(chat)
            }
            
            // Set up the relationship
            message.chat = chat
            chat.messages.append(message)
            
            // Insert the message
            modelContext.insert(message)
            
            try modelContext.save()
        } else {
            // Fallback to in-memory storage
            if chats[otherUserName] == nil {
                chats[otherUserName] = Chat(otherUserName: otherUserName, messages: [])
            }
            chats[otherUserName]?.messages.append(message)
        }
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
    
    private func createSampleChats() -> [Chat] {
        let now = Date()
        
        let sampleData = [
            ("Alice", "😊", [
                Message(content: "Hey! How's it going?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-3600)),
                Message(content: "Pretty good, thanks for asking!", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-1800))
            ]),
            ("Bob", "🤔", [
                Message(content: "Did you finish the project?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-7200)),
                Message(content: "Almost done, should be ready tomorrow", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-3600))
            ]),
            ("Charlie", "😎", [
                Message(content: "Want to grab lunch later?", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-1800))
            ]),
            ("Diana", "🌟", [
                Message(content: "The meeting is scheduled for 3 PM", isFromCurrentUser: false, timestamp: now.addingTimeInterval(-900)),
                Message(content: "Perfect, I'll be there", isFromCurrentUser: true, timestamp: now.addingTimeInterval(-300))
            ])
        ]
        
        var chats: [Chat] = []
        
        for (name, emoji, messageData) in sampleData {
            let profile = Profile(name: name, emoji: emoji, isOnline: Bool.random())
            let chat = Chat(otherUserName: name, messages: [], profile: profile)
            
            // Create messages and set up relationships
            let messages = messageData.map { messageInfo in
                let message = Message(content: messageInfo.content, isFromCurrentUser: messageInfo.isFromCurrentUser, timestamp: messageInfo.timestamp)
                message.chat = chat
                return message
            }
            
            chat.messages = messages
            chats.append(chat)
            
            // If we have a model context, insert everything
            if let modelContext = modelContext {
                modelContext.insert(profile)
                modelContext.insert(chat)
                for message in messages {
                    modelContext.insert(message)
                }
            }
        }
        
        return chats
    }
    
    private func setupSampleData() {
        let sampleChats = createSampleChats()
        for chat in sampleChats {
            chats[chat.otherUserName] = chat
        }
    }
    
    private func getRandomEmoji() -> String {
        let emojis = ["😊", "🤔", "😎", "🌟", "🚀", "💡", "🎉", "🔥", "⭐", "🌈"]
        return emojis.randomElement() ?? "😊"
    }
}