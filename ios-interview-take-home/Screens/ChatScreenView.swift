import SwiftUI

struct ChatScreenView: View {
    let chat: Chat
    
    var body: some View {
        VStack {
            Text("Chat with \(chat.otherUserName)")
                .font(.title)
            
            Text("This screen will be implemented in Phase 8")
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .navigationTitle(chat.otherUserName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChatScreenView(chat: Chat.sample)
    }
}