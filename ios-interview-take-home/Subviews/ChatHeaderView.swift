import SwiftUI

struct ChatHeaderView: View {
    let chat: Chat
    let onBackTap: () -> Void
    let onProfileTap: () -> Void
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Back button
            Button(action: onBackTap) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            
            // Profile section - tappable
            Button(action: onProfileTap) {
                HStack(spacing: Theme.Spacing.sm) {
                    // Profile avatar with online indicator
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(chat.profile?.emoji ?? "👤")
                                    .font(.title2)
                            )
                        
                        // Online status indicator
                        if chat.profile?.isOnline == true {
                            Circle()
                                .fill(Theme.Colors.success)
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(chat.otherUserName)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(chat.profile?.isOnline == true ? "Online" : "Offline")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // Menu button only
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            // Dark header background like in screenshots
            Color.black
                .ignoresSafeArea(edges: .top)
        )
    }
}

#Preview {
    let sampleChat = Chat(
        otherUserName: "Keisya",
        messages: [],
        profile: Profile(name: "Keisya", emoji: "👩🏻‍💼", isOnline: true)
    )
    
    return ChatHeaderView(
        chat: sampleChat,
        onBackTap: {},
        onProfileTap: {}
    )
    .background(Color.black)
}