import SwiftUI

struct ModernInputBarView: View {
    @Binding var text: String
    @FocusState private var isTextFieldFocused: Bool
    @State private var isRecording = false
    @State private var showingImagePicker = false
    @State private var showingAttachmentOptions = false
    @State private var recordingTimer: Timer?
    
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                HStack(spacing: Theme.Spacing.sm) {
                    TextField("Tap and type!", text: $text)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(.plain)
                        .font(Theme.Typography.body)
                        .foregroundColor(.white)
                        .accentColor(Theme.Colors.primary)
                    
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
                text = "📷 Photo sent"
                onSend()
            }
        }
        // NOTE: These are mocked for now
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
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        isRecording = true
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            stopRecording()
        }
    }
    
    private func stopRecording() {
        isRecording = false
        recordingTimer?.invalidate()
        recordingTimer = nil
        
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
