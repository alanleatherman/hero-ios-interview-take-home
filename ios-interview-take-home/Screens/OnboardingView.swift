import SwiftUI

struct OnboardingView: View {
    @Environment(\.interactors) private var interactors
    @Environment(\.appState) private var appState
    
    @State private var name = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            VStack(spacing: Theme.Spacing.md) {
                TypewriterText.themed(
                    "Welcome to Messages",
                    style: .largeTitle,
                    color: Theme.Colors.primaryText,
                    speed: 0.06
                )
                
                TypewriterText.themed(
                    "What's your name?",
                    style: .title2,
                    color: Theme.Colors.secondaryText,
                    speed: 0.08,
                    startDelay: 1.2
                )
            }
            
            VStack(spacing: Theme.Spacing.lg) {
                ProfileImageButton(
                    selectedImage: selectedImage,
                    action: { showingImagePicker = true }
                )
                
                TextField("", text: $name, prompt: Text("Enter your name").foregroundColor(.gray.opacity(0.7)))
                    .textFieldStyle(PurpleTextFieldStyle())
                    .font(Theme.Typography.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Theme.Colors.primaryText)
                    .accessibilityLabel("Name input field")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: completeOnboarding) {
                Text("Get Chatting")
                    .font(Theme.Typography.headline)
                    .foregroundColor(Theme.Colors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .fill(name.isEmpty ? Color.gray : Theme.Colors.primary)
                    )
                    .animation(Theme.Animation.quick, value: name.isEmpty)
            }
            .disabled(name.isEmpty)
            .padding(.horizontal, Theme.Spacing.xl)
            .padding(.bottom, 50)
            .accessibilityLabel("Complete onboarding and start chatting")
        }
        .background(Theme.Colors.background)
        .sheet(isPresented: $showingImagePicker) {
            ProfileImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func completeOnboarding() {
        Task {
            let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
            appState.userState.completeOnboarding(name: name, profileImage: imageData)
            
            await interactors.userInteractor.completeOnboarding(name: name, profileImage: imageData)
            
            onComplete()
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .inject(AppContainer(
            appState: AppState(),
            interactors: .stub
        ))
}
