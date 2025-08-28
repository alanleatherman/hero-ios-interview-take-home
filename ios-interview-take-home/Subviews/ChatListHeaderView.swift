import SwiftUI

struct ChatListHeaderView: View {
    let onProfileTap: () -> Void
    @State private var currentTime = Date()
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            // Top section with logo and profile
            HStack {
                // App logo/name (like pesan in screenshot)
                HStack(spacing: 4) {
                    Text("pesan")
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
                            
                            // Notification badge
                            Circle()
                                .fill(Theme.Colors.primary)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
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
                        TypewriterText.themed(
                            greetingText,
                            style: .largeTitle,
                            color: .white,
                            speed: 0.08
                        )
                        
                        TypewriterText.themed(
                            "User",
                            style: .largeTitle,
                            color: .white,
                            speed: 0.08,
                            startDelay: 1.0
                        )
                        
                        Text("32 new messages are coming")
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
            
            // Filter tabs (like in screenshots)
            HStack(spacing: Theme.Spacing.sm) {
                FilterTab(title: "All", isSelected: true)
                FilterTab(title: "New Messages", isSelected: false)
                FilterTab(title: "Groups", isSelected: false)
                FilterTab(title: "Calls", isSelected: false)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.sm)
        .background(Color.black)
        .onAppear {
            // Update time periodically
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                currentTime = Date()
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
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
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
}

#Preview {
    ChatListHeaderView(onProfileTap: {})
        .background(Color.black)
}