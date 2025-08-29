import Foundation
import SwiftData

enum ChatError: LocalizedError {
    case persistenceFailure(Error)
    case networkSimulationFailure
    case dataCorruption
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .persistenceFailure:
            return "Failed to save or load messages"
        case .networkSimulationFailure:
            return "Failed to simulate network response"
        case .dataCorruption:
            return "Message data appears to be corrupted"
        case .unknownError(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

class ChatWebRepository: ChatRepositoryProtocol {
    private var modelContext: ModelContext?
    private var chats: [String: Chat] = [:]
    private let queue = DispatchQueue(label: "ChatWebRepository", qos: .userInitiated)
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    // MARK: - ChatRepositoryProtocol Implementation
    
    func getAllChats() async throws -> [Chat] {
        if let modelContext = modelContext {
            let descriptor = FetchDescriptor<Chat>()
            
            let persistedChats: [Chat]
            do {
                persistedChats = try modelContext.fetch(descriptor)
            } catch {
                print("SwiftData fetch failed, falling back to in-memory: \(error)")

                if chats.isEmpty {
                    setupSampleData()
                }
                return Array(chats.values)
            }
            
            if persistedChats.isEmpty {
                let sampleChats = createSampleChats()
                do {
                    for chat in sampleChats {
                        modelContext.insert(chat)
                    }
                    try modelContext.save()
                    return sampleChats
                } catch {
                    print("Failed to save sample data to SwiftData: \(error)")
                    return sampleChats
                }
            }
            
            return persistedChats
        } else {
            if chats.isEmpty {
                setupSampleData()
            }
            return Array(chats.values)
        }
    }
    
    func getChat(with otherUserName: String) async throws -> Chat? {
        let allChats = try await getAllChats()
        return allChats.first { $0.otherUserName == otherUserName }
    }
    
    func sendMessage(_ content: String, to otherUserName: String) async throws -> Message {
        let now = Date()
        let message = Message(content: content, isFromCurrentUser: true, timestamp: now)
        
        // Add message to chat
        try await addMessage(message, to: otherUserName)
        
        try? await Task.sleep(for: .seconds(1))
        
        let fakeResponse = await getFakeResponse(for: content)
        let responseMessage = Message(content: fakeResponse, isFromCurrentUser: false, timestamp: now.addingTimeInterval(2))
        
        try await addMessage(responseMessage, to: otherUserName)
        
        return responseMessage
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
            let descriptor = FetchDescriptor<Chat>(predicate: #Predicate<Chat> { chat in
                chat.otherUserName == otherUserName
            })
            
            let existingChats: [Chat]
            do {
                existingChats = try modelContext.fetch(descriptor)
            } catch {
                print("Failed to fetch existing chat, falling back to in-memory: \(error)")

                if chats[otherUserName] == nil {
                    chats[otherUserName] = Chat(otherUserName: otherUserName, messages: [])
                }
                chats[otherUserName]?.messages.append(message)
                return
            }
            
            let chat: Chat
            if let existingChat = existingChats.first {
                chat = existingChat
            } else {
                // Create new chat if it doesn't exist
                let profile = Profile(name: otherUserName, emoji: getRandomEmoji(), isOnline: Bool.random())
                chat = Chat(otherUserName: otherUserName, messages: [], profile: profile)
                
                modelContext.insert(profile)
                modelContext.insert(chat)
            }
            
            modelContext.insert(message)
            message.chat = chat
            chat.messages.append(message)
            
            do {
                try modelContext.save()
            } catch {
                print("Failed to save message to SwiftData: \(error)")
                // Remove from SwiftData context if save failed to prevent stale references
                modelContext.delete(message)
                // Fallback to in-memory
                if chats[otherUserName] == nil {
                    chats[otherUserName] = Chat(otherUserName: otherUserName, messages: [])
                }
                chats[otherUserName]?.messages.append(message)
            }
        } else {
            // Fallback to in-memory storage
            if chats[otherUserName] == nil {
                chats[otherUserName] = Chat(otherUserName: otherUserName, messages: [])
            }
            chats[otherUserName]?.messages.append(message)
        }
    }
    
    private func getFakeResponse(for message: String) async -> String {
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
    
    func clearAllData() async throws {
        // Clear in-memory storage first
        chats.removeAll()
        
        // Clear SwiftData storage if available
        if let modelContext = modelContext {
            do {
                // Delete all Chat entities
                let chatDescriptor = FetchDescriptor<Chat>()
                let allChats = try modelContext.fetch(chatDescriptor)
                for chat in allChats {
                    modelContext.delete(chat)
                }
                
                // Delete all Profile entities
                let profileDescriptor = FetchDescriptor<Profile>()
                let allProfiles = try modelContext.fetch(profileDescriptor)
                for profile in allProfiles {
                    modelContext.delete(profile)
                }
                
                // Delete all Message entities
                let messageDescriptor = FetchDescriptor<Message>()
                let allMessages = try modelContext.fetch(messageDescriptor)
                for message in allMessages {
                    modelContext.delete(message)
                }
                
                try modelContext.save()
                print("Cleared all persistent chat data")
            } catch {
                print("Failed to clear SwiftData storage: \(error)")
                // The app can continue functioning with in-memory storage
            }
        }
    }
    
    private func getRandomEmoji() -> String {
        let emojis = ["😊", "🤔", "😎", "🌟", "🚀", "💡", "🎉", "🔥", "⭐", "🌈"]
        return emojis.randomElement() ?? "😊"
    }
}
