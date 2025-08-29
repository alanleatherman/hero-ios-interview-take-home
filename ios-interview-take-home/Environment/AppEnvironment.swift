import Foundation
import SwiftData
import OSLog

extension Logger {
    static let app = Logger(subsystem: Bundle.main.bundleIdentifier ?? "MessagingApp", category: "App")
}

@MainActor
struct AppEnvironment {
    let option: Option
    let appContainer: AppContainer
    
    enum Option: String {
        case preview
        case local
        case staging
        case production
    }
    
    static let current: Option = {
        #if PREVIEW
        return .preview
        #elseif DEBUG
        return .local
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }()
}

extension AppEnvironment {
    @MainActor
    static func bootstrap(_ optionOverride: AppEnvironment.Option? = nil, modelContext: ModelContext? = nil) -> AppEnvironment {
        let option = optionOverride ?? AppEnvironment.current
        Logger.app.info("Current environment: \(option.rawValue)")
        
        switch option {
        case .preview:
            return createPreviewEnvironment()
        case .local:
            return createLocalEnvironment(modelContext: modelContext)
        case .staging, .production:
            return createWebEnvironment(option: option, modelContext: modelContext)
        }
    }
    
    private static func createPreviewEnvironment() -> AppEnvironment {
        let appState = AppState()
        let interactors = createPreviewInteractors(appState: appState)
        let container = AppContainer(appState: appState, interactors: interactors)
        
        return AppEnvironment(option: .preview, appContainer: container)
    }
    
    private static func createLocalEnvironment(modelContext: ModelContext? = nil) -> AppEnvironment {
        let appState = AppState()
        let interactors = createWebInteractors(appState: appState, modelContext: modelContext)
        let container = AppContainer(appState: appState, interactors: interactors)
        
        return AppEnvironment(option: .local, appContainer: container)
    }
    
    private static func createWebEnvironment(option: AppEnvironment.Option, modelContext: ModelContext? = nil) -> AppEnvironment {
        let appState = AppState()
        let interactors = createWebInteractors(appState: appState, modelContext: modelContext)
        let container = AppContainer(appState: appState, interactors: interactors)
        
        return AppEnvironment(option: option, appContainer: container)
    }
    
    private static func createPreviewInteractors(appState: AppState) -> AppContainer.Interactors {
        let chatInteractor = ChatInteractor(
            repository: ChatPreviewRepository(),
            appState: appState
        )
        let userInteractor = UserInteractor(
            repository: UserPreviewRepository.onboardingNotCompleted
        )
        
        return AppContainer.Interactors(
            chatInteractor: chatInteractor,
            userInteractor: userInteractor
        )
    }
    
    private static func createWebInteractors(appState: AppState, modelContext: ModelContext? = nil) -> AppContainer.Interactors {
        let chatInteractor = ChatInteractor(
            repository: ChatWebRepository(modelContext: modelContext),
            appState: appState
        )
        let userInteractor = UserInteractor(
            repository: UserWebRepository(modelContext: modelContext)
        )
        
        return AppContainer.Interactors(
            chatInteractor: chatInteractor,
            userInteractor: userInteractor
        )
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