import SwiftUI

struct ModernChatRowView: View {
    let chat: Chat
    @Environment(\.appState) private var appState
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            profileAvatarView
            chatContentView
        }
        .padding(Theme.Spacing.md)
        .background(backgroundView)
        .overlay(borderView)
    }
    
    // MARK: - Subviews
    
    private var profileAvatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(chat.profile?.emoji ?? "👤")
                        .font(.title2)
                )
            
            if chat.profile?.isOnline == true {
                onlineIndicator
            }
        }
    }
    
    private var onlineIndicator: some View {
        Circle()
            .fill(Theme.Colors.success)
            .frame(width: 14, height: 14)
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
    }
    
    private var chatContentView: some View {
        VStack(alignment: .leading, spacing: 4) {
            headerRow
            if let lastMessage = chat.lastMessage {
                messageRow(lastMessage)
            }
        }
    }
    
    private var headerRow: some View {
        HStack {
            Text(chat.otherUserName)
                .font(Theme.Typography.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            if let lastMessage = chat.lastMessage {
                Text(formatTime(lastMessage.timestamp))
                    .font(Theme.Typography.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func messageRow(_ lastMessage: Message) -> some View {
        HStack {
            Text(lastMessage.content)
                .font(Theme.Typography.body)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Spacer()
            
            if chat.hasUnreadMessages {
                unreadBadge
            }
        }
    }
    
    private var unreadBadge: some View {
        Text("1")
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(minWidth: 20, minHeight: 20)
            .background(
                Circle()
                    .fill(Theme.Colors.primary)
            )
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
            .fill(Color.gray.opacity(0.1))
    }
    
    private var borderView: some View {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    }
    
    private func formatTime(_ date: Date) -> String {
        return date.chatDisplayFormat()
    }
}

#Preview {
    VStack(spacing: 8) {
        ModernChatRowView(
            chat: Chat(
                otherUserName: "Keisya",
                messages: [
                    Message(content: "Good morning! How are you today?", isFromCurrentUser: false, timestamp: Date())
                ],
                profile: Profile(name: "Keisya", emoji: "👩🏻‍💼", isOnline: true)
            )
        )
        
        ModernChatRowView(
            chat: Chat(
                otherUserName: "Alex",
                messages: [
                    Message(content: "Hey, did you see the new project updates?", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3600))
                ],
                profile: Profile(name: "Alex", emoji: "👨🏻‍💻", isOnline: false)
            )
        )
    }
    .padding()
    .background(Color.black)
}
