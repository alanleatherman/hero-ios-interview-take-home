import SwiftUI

struct ProfileDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let chat: Chat
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.Spacing.xl) {
                Spacer()
                
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
                
                VStack(spacing: Theme.Spacing.sm) {
                    Text("\(chat.messages.count) messages")
                        .font(Theme.Typography.caption)
                        .foregroundColor(.gray)
                    
                    if let lastMessage = chat.messages.last {
                        Text("Last message: \(lastMessage.timestamp.formatted(date: .abbreviated, time: .shortened))")
                            .font(Theme.Typography.caption2)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
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
