import SwiftUI

struct ProfileImageButton: View {
    @State private var isBreathing = false
    
    let selectedImage: UIImage?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Theme.Colors.primary.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isBreathing ? 1.1 : 1.0)
                    .animation(Theme.Animation.breathing, value: isBreathing)
                
                Group {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.Colors.primary.opacity(0.3))
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Theme.Colors.primary, lineWidth: 3)
                        .scaleEffect(isBreathing ? 1.05 : 1.0)
                        .animation(Theme.Animation.breathing, value: isBreathing)
                )
                .themeShadow(Theme.Shadows.medium)
                
                if selectedImage == nil {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Theme.Colors.primary)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                )
                                .offset(x: -8, y: -8)
                        }
                    }
                    .frame(width: 100, height: 100)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Profile photo selection")
        .accessibilityHint("Tap to select a profile photo")
        .onAppear {
            isBreathing = true
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ProfileImageButton(selectedImage: nil) {}
        ProfileImageButton(selectedImage: UIImage(systemName: "person.fill")) {}
    }
    .padding()
}
