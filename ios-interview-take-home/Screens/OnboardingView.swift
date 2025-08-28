import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var name = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.interactors) private var interactors
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Welcome section
            VStack(spacing: 16) {
                Text("Welcome to Messages")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("What's your name?")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            // Profile setup
            VStack(spacing: 24) {
                // Profile image picker
                Button(action: { showingImagePicker = true }) {
                    Group {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 3)
                    )
                }
                .accessibilityLabel("Select profile photo")
                
                // Name input
                TextField("Enter your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Name input field")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Get Chatting button
            Button(action: completeOnboarding) {
                Text("Get Chatting")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(name.isEmpty ? Color.gray : Color.blue)
                    )
            }
            .disabled(name.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
            .accessibilityLabel("Complete onboarding and start chatting")
        }
        .sheet(isPresented: $showingImagePicker) {
            ProfileImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func completeOnboarding() {
        Task {
            let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
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