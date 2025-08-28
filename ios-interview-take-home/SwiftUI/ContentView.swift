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
                    Task {
                        await checkOnboardingStatus()
                    }
                })
            }
        }
        .task {
            // Check onboarding status on app launch
            await checkOnboardingStatus()
        }
        .onChange(of: appState.userState.hasCompletedOnboarding) { _, newValue in
            // React to changes in onboarding status (like sign out)
            if !newValue && hasCompletedOnboarding {
                // User signed out, reset to onboarding
                hasCompletedOnboarding = false
            }
        }
    }
    
    private func checkOnboardingStatus() async {
        hasCompletedOnboarding = await interactors.userInteractor.hasCompletedOnboarding()
        
        // Sync with app state
        if hasCompletedOnboarding {
            if let userProfile = await interactors.userInteractor.getUserProfile() {
                appState.userState.userName = userProfile.name
                appState.userState.profileImage = userProfile.profileImage
                appState.userState.hasCompletedOnboarding = true
            }
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isCheckingOnboarding = false
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
