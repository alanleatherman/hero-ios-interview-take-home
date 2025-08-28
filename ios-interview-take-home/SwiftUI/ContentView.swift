import SwiftUI

struct ContentView: View {
    @Environment(\.appState) private var appState
    @Environment(\.interactors) private var interactors
    @State private var hasCompletedOnboarding = false
    @State private var isCheckingOnboarding = true
    
    var body: some View {
        Group {
            if isCheckingOnboarding {
                // Loading state while checking onboarding status
                VStack(spacing: Theme.Spacing.sm) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .accentColor(Theme.Colors.primary)
                    Text("Loading...")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.secondaryText)
                        .padding(.top, Theme.Spacing.sm)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.Colors.background)
            } else if hasCompletedOnboarding {
                NavigationStack {
                    ChatListView()
                }
            } else {
                OnboardingView(onComplete: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasCompletedOnboarding = true
                    }
                })
            }
        }
        .task {
            // Check onboarding status on app launch
            hasCompletedOnboarding = await interactors.userInteractor.hasCompletedOnboarding()
            withAnimation(.easeInOut(duration: 0.3)) {
                isCheckingOnboarding = false
            }
        }
    }
}

#Preview {
    ContentView()
        .inject(AppContainer(
            appState: AppState(),
            interactors: .stub
        ))
} 
