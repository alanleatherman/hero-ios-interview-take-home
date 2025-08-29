import Foundation

// MARK: - Repository Protocols

protocol ChatRepositoryProtocol {
    func getAllChats() async throws -> [Chat]
    func getChat(with otherUserName: String) async throws -> Chat?
    func sendMessage(_ content: String, to otherUserName: String) async throws -> Message
    func loadCachedChats() async throws -> [Chat]
    func saveChat(_ chat: Chat) async throws
    func clearAllData() async throws
}

protocol UserRepositoryProtocol {
    func hasCompletedOnboarding() async throws -> Bool
    func saveUserProfile(name: String, profileImage: Data?) async throws
    func getUserProfile() async throws -> UserProfile?
    func clearUserProfile() async throws
}

// MARK: - Interactor Protocols

protocol ChatInteractorProtocol {
    func loadChats() async
    func sendMessage(_ content: String, to otherUserName: String) async
    func markChatAsRead(_ chat: Chat) async
    func clearAllData() async
}

protocol UserInteractorProtocol {
    func hasCompletedOnboarding() async -> Bool
    func completeOnboarding(name: String, profileImage: Data?) async
    func getUserProfile() async -> UserProfile?
    func updateProfile(name: String, profileImage: Data?) async
    func signOut() async
}
