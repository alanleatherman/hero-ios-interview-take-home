import SwiftUI

struct ModernInputBarView: View {
    @Binding var text: String
    let onSend: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    @State private var isRecording = false
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            // Plus button for attachments
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                    )
            }
            
            // Text input container
            HStack(spacing: Theme.Spacing.sm) {
                TextField("Tap and type!", text: $text)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(.plain)
                    .font(Theme.Typography.body)
                    .foregroundColor(.white)
                    .accentColor(Theme.Colors.primary)
                
                // Microphone button
                Button(action: toggleRecording) {
                    Image(systemName: isRecording ? "mic.fill" : "mic")
                        .font(.title3)
                        .foregroundColor(isRecording ? Theme.Colors.primary : .gray)
                        .scaleEffect(isRecording ? 1.2 : 1.0)
                        .animation(Theme.Animation.quick, value: isRecording)
                }
                
                // Camera button
                Button(action: {}) {
                    Image(systemName: "camera")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
            )
            
            // Send button (only when text exists)
            if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Button(action: onSend) {
                    Image(systemName: "arrow.up")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Theme.Colors.primary)
                        )
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            Color.black
                .ignoresSafeArea(edges: .bottom)
        )
        .animation(Theme.Animation.quick, value: text.isEmpty)
    }
    
    private func toggleRecording() {
        // TODO: Implement speech recognition
        isRecording.toggle()
    }
}

#Preview {
    VStack {
        Spacer()
        
        ModernInputBarView(
            text: .constant(""),
            onSend: {}
        )
    }
    .background(Color.black)
}