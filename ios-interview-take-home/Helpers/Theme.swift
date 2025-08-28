import SwiftUI

// MARK: - App Theme

struct Theme {
    
    // MARK: - Colors
    
    struct Colors {
        // Purple - Primary brand color
        static let primary = Color(red: 0.45, green: 0.35, blue: 0.85) // #7359D9
        static let primaryLight = Color(red: 0.55, green: 0.45, blue: 0.90)
        static let primaryDark = Color(red: 0.35, green: 0.25, blue: 0.75)
        
        // Secondary colors
        static let secondary = Color.secondary
        static let accent = primary
        
        // Message bubble colors
        static let sentMessage = primary
        static let sentMessageGradient = LinearGradient(
            colors: [primary, primaryLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let receivedMessage = Color(.systemGray6)
        
        // Background colors
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let surface = Color(.systemGray6)
        
        // Text colors
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let onPrimary = Color.white
        
        // Status colors
        static let success = Color.green
        static let error = Color.red
        static let warning = Color.orange
        
        // Online status
        static let online = Color.green
        static let offline = Color.gray
    }
    
    // MARK: - Spacing
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xl: CGFloat = 20
        static let circle: CGFloat = 50
    }
    
    // MARK: - Typography
    
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.medium)
        static let headline = Font.headline
        static let body = Font.body
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
    
    // MARK: - Shadows
    
    struct Shadows {
        static let light = Shadow(
            color: .black.opacity(0.05),
            radius: 1,
            x: 0,
            y: 1
        )
        
        static let medium = Shadow(
            color: .black.opacity(0.1),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let heavy = Shadow(
            color: .black.opacity(0.15),
            radius: 4,
            x: 0,
            y: 2
        )
    }
    
    // MARK: - Animation
    
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let breathing = SwiftUI.Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    }
}

// MARK: - Shadow Helper

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions for Theme

extension View {
    func themeShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    func primaryButton() -> some View {
        self
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(Theme.Colors.primary)
            )
            .themeShadow(Theme.Shadows.light)
    }
    
    func secondaryButton() -> some View {
        self
            .foregroundColor(Theme.Colors.primary)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(Theme.Colors.primary, lineWidth: 2)
            )
    }
}

// MARK: - Color Extensions

extension Color {
    static let themePrimary = Theme.Colors.primary
    static let themeSecondary = Theme.Colors.secondary
}
