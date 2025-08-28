import SwiftUI

struct ChatListHeaderView: View {
    let onProfileTap: () -> Void
    @Binding var selectedTab: String
    @State private var currentTime = Date()
    @Environment(\.appState) private var appState
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            // Top section with logo and profile
            HStack {
                // App logo/name
                HStack(spacing: 4) {
                    Text("Messages")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(Theme.Colors.primary)
                }
                
                Spacer()
                
                // Notification and profile buttons
                HStack(spacing: Theme.Spacing.sm) {
                    Button(action: {}) {
                        ZStack {
                            Image(systemName: "bell")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            // Notification badge - only show if there are unread messages
                            if appState.chatState.totalUnreadCount > 0 {
                                Circle()
                                    .fill(Theme.Colors.primary)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                    
                    Button(action: onProfileTap) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("👤")
                                    .font(.caption)
                            )
                    }
                }
            }
            
            // Greeting section (like in middle screenshot)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if appState.userState.hasShownTypewriter {
                            // Show static text after first time
                            Text(greetingText)
                                .font(Theme.Typography.largeTitle)
                                .foregroundColor(.white)
                            
                            Text(appState.userState.userName)
                                .font(Theme.Typography.largeTitle)
                                .foregroundColor(.white)
                        } else {
                            // Show typewriter effect only first time
                            TypewriterText.themed(
                                greetingText,
                                style: .largeTitle,
                                color: .white,
                                speed: 0.08
                            )
                            
                            TypewriterText.themed(
                                appState.userState.userName,
                                style: .largeTitle,
                                color: .white,
                                speed: 0.08,
                                startDelay: 1.0
                            )
                        }
                        
                        Text(newMessagesText)
                            .font(Theme.Typography.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Sun/moon icon based on time
                    Image(systemName: timeBasedIcon)
                        .font(.title)
                        .foregroundColor(.yellow)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Filter tabs (removed Calls, added functionality)
            HStack(spacing: Theme.Spacing.sm) {
                FilterTab(
                    title: "All", 
                    isSelected: selectedTab == "All",
                    onTap: { selectedTab = "All" }
                )
                FilterTab(
                    title: "New Messages", 
                    isSelected: selectedTab == "New Messages",
                    onTap: { selectedTab = "New Messages" }
                )
                FilterTab(
                    title: "Groups", 
                    isSelected: selectedTab == "Groups",
                    onTap: { selectedTab = "Groups" }
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, Theme.Spacing.md)
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.sm)
        .background(Color.black)
        .onAppear {
            // Update time periodically
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                currentTime = Date()
            }
            
            // Mark typewriter as shown after delay
            if !appState.userState.hasShownTypewriter {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    appState.userState.markTypewriterShown()
                }
            }
        }
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    private var timeBasedIcon: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        return hour >= 6 && hour < 18 ? "sun.max" : "moon.stars"
    }
    
    private var newMessagesText: String {
        let count = appState.chatState.totalUnreadCount
        if count == 0 {
            return "All caught up!"
        } else if count == 1 {
            return "1 new message"
        } else {
            return "\(count) new messages"
        }
    }
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(Theme.Typography.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.white.opacity(0.1) : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ChatListHeaderView(onProfileTap: {}, selectedTab: .constant("All"))
        .background(Color.black)
        .inject(AppContainer(
            appState: AppState(),
            interactors: .stub
        ))
}