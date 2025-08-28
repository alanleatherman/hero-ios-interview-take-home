import Foundation
import SwiftUI

// MARK: - App Container

struct AppContainer {
    let appState: AppState
    let interactors: Interactors
    
    init(appState: AppState = AppState(), interactors: Interactors = .stub) {
        self.appState = appState
        self.interactors = interactors
    }
    
    struct Interactors {
        let chatInteractor: ChatInteractorProtocol
        let userInteractor: UserInteractorProtocol
        
        static var stub: Self {
            .init(
                chatInteractor: StubChatInteractor(),
                userInteractor: StubUserInteractor()
            )
        }
    }
    
    static var preview: AppContainer {
        return MainActor.assumeIsolated {
            let appState = AppState.sample
            let chatInteractor = ChatInteractor(
                repository: ChatPreviewRepository(),
                appState: appState
            )
            let userInteractor = UserInteractor(
                repository: UserPreviewRepository.onboardingCompleted
            )
            
            let interactors = AppContainer.Interactors(
                chatInteractor: chatInteractor,
                userInteractor: userInteractor
            )
            
            return AppContainer(appState: appState, interactors: interactors)
        }
    }
    
    static var stub: AppContainer {
        return MainActor.assumeIsolated {
            let appState = AppState()
            return AppContainer(appState: appState, interactors: .stub)
        }
    }
}

// MARK: - Environment Keys

private struct AppContainerKey: EnvironmentKey {
    static let defaultValue = AppContainer(appState: AppState(), interactors: .stub)
}

private struct AppStateKey: EnvironmentKey {
    static let defaultValue = AppState()
}

private struct InteractorsKey: EnvironmentKey {
    static let defaultValue = AppContainer.Interactors.stub
}

// MARK: - Environment Values Extensions

extension EnvironmentValues {
    var container: AppContainer {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
    
    var appState: AppState {
        get { self[AppStateKey.self] }
        set { self[AppStateKey.self] = newValue }
    }
    
    var interactors: AppContainer.Interactors {
        get { self[InteractorsKey.self] }
        set { self[InteractorsKey.self] = newValue }
    }
}

// MARK: - View Extension for Dependency Injection

extension View {
    func inject(_ container: AppContainer) -> some View {
        self
            .environment(\.container, container)
            .environment(\.appState, container.appState)
            .environment(\.interactors, container.interactors)
    }
}

// MARK: - Preview Helpers

extension AppContainer {
    static let onboarding: AppContainer = {
        return MainActor.assumeIsolated {
            let appState = AppState()
            let interactors = AppContainer.Interactors(
                chatInteractor: ChatInteractor(
                    repository: ChatPreviewRepository(),
                    appState: appState
                ),
                userInteractor: UserInteractor(
                    repository: UserPreviewRepository.onboardingNotCompleted
                )
            )
            return AppContainer(appState: appState, interactors: interactors)
        }
    }()
    
    static let loading: AppContainer = {
        return MainActor.assumeIsolated {
            let appState = AppState.loading
            let interactors = AppContainer.Interactors(
                chatInteractor: ChatInteractor(
                    repository: ChatPreviewRepository(),
                    appState: appState
                ),
                userInteractor: UserInteractor(
                    repository: UserPreviewRepository.onboardingCompleted
                )
            )
            return AppContainer(appState: appState, interactors: interactors)
        }
    }()
}
