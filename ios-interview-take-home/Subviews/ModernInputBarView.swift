import SwiftUI

struct ModernInputBarView: View {
    @Binding var text: String
    let onSend: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    @State private var isRecording = false
    @State private var showingImagePicker = false
    @State private var showingAttachmentOptions = false
    @State private var recordingTimer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            // Recording indicator
            if isRecording {
                HStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isRecording ? 1.2 : 1.0)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: isRecording)
                    
                    Text("Recording... Tap mic to stop")
                        .font(Theme.Typography.caption2)
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.xs)
            }
            
            HStack(spacing: Theme.Spacing.sm) {
            // Plus button for attachments
            Button(action: { showingAttachmentOptions = true }) {
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
                
                // Microphone button with recording indicator
                Button(action: toggleRecording) {
                    ZStack {
                        Image(systemName: isRecording ? "mic.fill" : "mic")
                            .font(.title3)
                            .foregroundColor(isRecording ? Theme.Colors.primary : .gray)
                            .scaleEffect(isRecording ? 1.2 : 1.0)
                        
                        if isRecording {
                            Circle()
                                .stroke(Theme.Colors.primary, lineWidth: 2)
                                .frame(width: 24, height: 24)
                                .scaleEffect(isRecording ? 1.5 : 1.0)
                                .opacity(isRecording ? 0.6 : 0)
                        }
                    }
                    .animation(Theme.Animation.quick, value: isRecording)
                }
                
                // Camera button
                Button(action: { showingImagePicker = true }) {
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
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker { image in
                // Send image as message
                text = "📷 Photo sent"
                onSend()
            }
        }
        .actionSheet(isPresented: $showingAttachmentOptions) {
            ActionSheet(
                title: Text("Add Attachment"),
                buttons: [
                    .default(Text("📷 Camera")) {
                        showingImagePicker = true
                    },
                    .default(Text("📁 Files")) {
                        text = "📁 File attachment"
                        onSend()
                    },
                    .default(Text("📍 Location")) {
                        text = "📍 Location shared"
                        onSend()
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private func toggleRecording() {
        if isRecording {
            // Stop recording
            stopRecording()
        } else {
            // Start recording
            startRecording()
        }
    }
    
    private func startRecording() {
        isRecording = true
        
        // Auto-stop after 5 seconds (simulator-friendly)
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            stopRecording()
        }
    }
    
    private func stopRecording() {
        isRecording = false
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        // Send voice message
        text = "🎤 Voice message (5s)"
        onSend()
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