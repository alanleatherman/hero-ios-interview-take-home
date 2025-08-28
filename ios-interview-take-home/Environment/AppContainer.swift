import Foundation
import SwiftUI

// MARK: - App Container

@Observable
class AppContainer {
    let appState: AppState
    let interactors: Interactors
    
    struct Interactors {
        let chatInteractor: ChatInteractorProtocol
        let userInteractor: UserInteractorProtocol
        
        static let stub = Interactors(
            chatInteractor: ChatInteractor(
                repository: ChatPreviewRepository(),
                appState: AppState()
            ),
            userInteractor: UserInteractor(
                repository: UserPreviewRepository.onboardingNotCompleted
            )
        )
        
        static let preview = Interactors(
            chatInteractor: ChatInteractor(
                repository: ChatPreviewRepository(),
                appState: AppState.sample
            ),
            userInteractor: UserInteractor(
                repository: UserPreviewRepository.onboardingCompleted
            )
        )
    }
    
    init(appState: AppState, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
}

// MARK: - Environment Values Extensions

extension EnvironmentValues {
    @Entry var container: AppContainer = AppContainer(
        appState: AppState(), 
        interactors: .stub
    )
    
    @Entry var appState: AppState = AppState()
    
    @Entry var interactors: AppContainer.Interactors = .stub
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
    static let preview: AppContainer = {
        let appState = AppState.sample
        let interactors = Interactors(
            chatInteractor: ChatInteractor(
                repository: ChatPreviewRepository(),
                appState: appState
            ),
            userInteractor: UserInteractor(
                repository: UserPreviewRepository.onboardingCompleted
            )
        )
        return AppContainer(appState: appState, interactors: interactors)
    }()
    
    static let onboarding: AppContainer = {
        let appState = AppState()
        let interactors = Interactors(
            chatInteractor: ChatInteractor(
                repository: ChatPreviewRepository(),
                appState: appState
            ),
            userInteractor: UserInteractor(
                repository: UserPreviewRepository.onboardingNotCompleted
            )
        )
        return AppContainer(appState: appState, interactors: interactors)
    }()
    
    static let loading: AppContainer = {
        let appState = AppState.loading
        let interactors = Interactors(
            chatInteractor: ChatInteractor(
                repository: ChatPreviewRepository(),
                appState: appState
            ),
            userInteractor: UserInteractor(
                repository: UserPreviewRepository.onboardingCompleted
            )
        )
        return AppContainer(appState: appState, interactors: interactors)
    }()
}