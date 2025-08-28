import SwiftUI

struct ProfileDetailView: View {
    let chat: Chat
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.Spacing.xl) {
                Spacer()
                
                // Large profile avatar
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text(chat.profile?.emoji ?? "👤")
                            .font(.system(size: 60))
                    )
                    .overlay(
                        Circle()
                            .stroke(Theme.Colors.primary, lineWidth: 3)
                    )
                
                // Profile info
                VStack(spacing: Theme.Spacing.sm) {
                    Text(chat.otherUserName)
                        .font(Theme.Typography.largeTitle)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(chat.profile?.isOnline == true ? Theme.Colors.success : Theme.Colors.offline)
                            .frame(width: 8, height: 8)
                        
                        Text(chat.profile?.isOnline == true ? "Online" : "Offline")
                            .font(Theme.Typography.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Action buttons
                VStack(spacing: Theme.Spacing.md) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call")
                        }
                        .font(Theme.Typography.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(Theme.Colors.primary)
                        )
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "video.fill")
                            Text("Video Call")
                        }
                        .font(Theme.Typography.headline)
                        .foregroundColor(Theme.Colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .stroke(Theme.Colors.primary, lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal, Theme.Spacing.xl)
                
                Spacer()
            }
            .background(Color.black)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
                .foregroundColor(Theme.Colors.primary)
            )
        }
    }
}

#Preview {
    let sampleChat = Chat(
        otherUserName: "Keisya",
        messages: [],
        profile: Profile(name: "Keisya", emoji: "👩🏻‍💼", isOnline: true)
    )
    
    return ProfileDetailView(chat: sampleChat)
}