import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
            if message.isFromCurrentUser {
                Spacer(minLength: 60)
                sentMessageBubble
            } else {
                receivedMessageBubble
                Spacer(minLength: 60)
            }
        }
        .accessibilityLabel(accessibilityText)
    }
    
    private var sentMessageBubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.content)
                .font(Theme.Typography.body)
                .foregroundColor(.white)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .background(
                    // Purple gradient like in screenshots
                    LinearGradient(
                        colors: [Theme.Colors.primary, Theme.Colors.primaryLight],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 6,
                        topTrailingRadius: 20
                    )
                )
                .shadow(color: Theme.Colors.primary.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Timestamp
            Text(formatTime(message.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.trailing, 4)
        }
    }
    
    private var receivedMessageBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(message.content)
                .font(Theme.Typography.body)
                .foregroundColor(.white)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .background(
                    // Dark gray bubble like in screenshots
                    Color.gray.opacity(0.3)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 6,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 20,
                        topTrailingRadius: 20
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            // Timestamp
            Text(formatTime(message.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.leading, 4)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        return date.messageTimeFormat()
    }
    
    private var accessibilityText: String {
        let sender = message.isFromCurrentUser ? "You" : "Other person"
        let time = formatTime(message.timestamp)
        return "\(sender) said at \(time): \(message.content)"
    }
}

#Preview {
    VStack(spacing: 16) {
        MessageBubbleView(
            message: Message(
                content: "Hey! How are you doing today?",
                isFromCurrentUser: false,
                timestamp: Date()
            )
        )
        
        MessageBubbleView(
            message: Message(
                content: "I'm doing great! Thanks for asking 😊 How about you?",
                isFromCurrentUser: true,
                timestamp: Date()
            )
        )
        
        MessageBubbleView(
            message: Message(
                content: "That's wonderful to hear! I'm having a fantastic day as well.",
                isFromCurrentUser: false,
                timestamp: Date()
            )
        )
    }
    .padding()
    .background(Color.black)
}