import SwiftUI
import Foundation

struct ChatRowView: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile emoji avatar
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(chat.profile?.emoji ?? "😊")
                        .font(.title2)
                )
                .accessibilityLabel("Profile picture for \(chat.otherUserName)")
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chat.otherUserName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let lastMessage = chat.messages.last {
                        Text(formatTime(lastMessage.timestamp))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    if let lastMessage = chat.messages.last {
                        Text(lastMessage.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    } else {
                        Text("No messages yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    
                    Spacer()
                    
                    // Online status indicator
                    if let profile = chat.profile {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(profile.isOnline ? Color.green : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        // Check if it's today
        if calendar.isDate(date, inSameDayAs: now) {
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        // Check if it's yesterday
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday"
        }
        
        // Check if it's within this week
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now),
           weekInterval.contains(date) {
            formatter.dateFormat = "EEEE" // Day of week
            return formatter.string(from: date)
        }
        
        // Older dates
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private var accessibilityText: String {
        let onlineStatus = chat.profile?.isOnline == true ? "online" : "offline"
        let lastMessageText = chat.messages.last?.content ?? "No messages"
        let timeText = chat.messages.last.map { formatTime($0.timestamp) } ?? ""
        
        return "Chat with \(chat.otherUserName), \(onlineStatus). Last message: \(lastMessageText). \(timeText)"
    }
}

#Preview {
    List {
        ChatRowView(chat: Chat.sample)
        ChatRowView(chat: Chat(
            otherUserName: "Alice",
            messages: [],
            profile: Profile(name: "Alice", emoji: "😊", isOnline: false)
        ))
    }
    .listStyle(.plain)
}