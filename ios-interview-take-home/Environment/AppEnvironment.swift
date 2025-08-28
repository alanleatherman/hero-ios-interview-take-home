import Foundation
import SwiftData

// MARK: - App Environment

enum AppEnvironment {
    case production
    case staging  
    case local
    
    static var current: AppEnvironment {
        #if DEBUG
        return .local
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
    
    func createContainer(modelContext: ModelContext? = nil) -> AppContainer {
        let appState = AppState()
        let chatRepository = createChatRepository(modelContext: modelContext)
        let userRepository = createUserRepository(modelContext: modelContext)
        
        let interactors = AppContainer.Interactors(
            chatInteractor: ChatInteractor(
                repository: chatRepository,
                appState: appState
            ),
            userInteractor: UserInteractor(
                repository: userRepository
            )
        )
        
        return AppContainer(appState: appState, interactors: interactors)
    }
    
    private func createChatRepository(modelContext: ModelContext?) -> ChatRepositoryProtocol {
        switch self {
        case .production, .staging:
            return ChatWebRepository(modelContext: modelContext)
        case .local:
            // In local development, use web repository with persistence for testing
            return ChatWebRepository(modelContext: modelContext)
        }
    }
    
    private func createUserRepository(modelContext: ModelContext?) -> UserRepositoryProtocol {
        switch self {
        case .production, .staging:
            return UserWebRepository(modelContext: modelContext)
        case .local:
            // In local development, use web repository with persistence for testing
            return UserWebRepository(modelContext: modelContext)
        }
    }
}

// MARK: - SwiftData Configuration

struct SwiftDataConfiguration {
    static func createModelContainer() -> ModelContainer {
        let schema = Schema([
            Chat.self,
            Message.self,
            Profile.self,
            UserProfile.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    static func createInMemoryContainer() -> ModelContainer {
        let schema = Schema([
            Chat.self,
            Message.self,
            Profile.self,
            UserProfile.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create in-memory ModelContainer: \(error)")
        }
    }
}