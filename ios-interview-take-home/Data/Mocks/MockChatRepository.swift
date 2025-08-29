import Foundation

// MARK: - Mock Chat Repository for Testing

@MainActor
class MockChatRepository: ChatRepositoryProtocol {
    var chats: [Chat] = []
    var shouldThrowError = false
    var errorToThrow: Error = NSError(domain: "TestError", code: 1, userInfo: nil)
    
    func getAllChats() async throws -> [Chat] {
        if shouldThrowError {
            throw errorToThrow
        }
        return chats
    }
    
    func getChat(with otherUserName: String) async throws -> Chat? {
        if shouldThrowError {
            throw errorToThrow
        }
        return chats.first { $0.otherUserName == otherUserName }
    }
    
    func sendMessage(_ content: String, to otherUserName: String) async throws -> Message {
        if shouldThrowError {
            throw errorToThrow
        }
        
        let message = Message(content: content, isFromCurrentUser: true)
        
        var chat = chats.first { $0.otherUserName == otherUserName }
        if chat == nil {
            chat = Chat(otherUserName: otherUserName, messages: [])
            chats.append(chat!)
        }
        
        chat?.messages.append(message)
        return message
    }
    
    func loadCachedChats() async throws -> [Chat] {
        if shouldThrowError {
            throw errorToThrow
        }
        return chats
    }
    
    func saveChat(_ chat: Chat) async throws {
        if shouldThrowError {
            throw errorToThrow
        }
        
        if let index = chats.firstIndex(where: { $0.otherUserName == chat.otherUserName }) {
            chats[index] = chat
        } else {
            chats.append(chat)
        }
    }
    
    func clearAllData() async throws {
        if shouldThrowError {
            throw errorToThrow
        }
        chats.removeAll()
    }
}
