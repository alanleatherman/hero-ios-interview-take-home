import Foundation

// MARK: - Error Types

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

enum UserError: LocalizedError {
    case onboardingDataMissing
    case profileSaveFailure(Error)
    case profileLoadFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .onboardingDataMissing:
            return "Onboarding data is missing or corrupted"
        case .profileSaveFailure:
            return "Failed to save user profile"
        case .profileLoadFailure:
            return "Failed to load user profile"
        }
    }
}

// MARK: - Repository Protocols

protocol ChatRepositoryProtocol {
    func getAllChats() async throws -> [Chat]
    func getChat(with otherUserName: String) async throws -> Chat?
    func sendMessage(_ content: String, to otherUserName: String) async throws -> Message
    func loadCachedChats() async throws -> [Chat]
    func saveChat(_ chat: Chat) async throws
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
}

protocol UserInteractorProtocol {
    func hasCompletedOnboarding() async -> Bool
    func completeOnboarding(name: String, profileImage: Data?) async
    func getUserProfile() async -> UserProfile?
    func updateProfile(name: String, profileImage: Data?) async
    func signOut() async
}