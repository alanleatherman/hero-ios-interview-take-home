import SwiftUI

struct TypewriterText: View {
    @State private var displayedText = ""
    @State private var currentIndex = 0
    
    let text: String
    let font: Font
    let color: Color
    let speed: TimeInterval
    let startDelay: TimeInterval
    
    init(
        _ text: String,
        font: Font = .body,
        color: Color = .primary,
        speed: TimeInterval = 0.05,
        startDelay: TimeInterval = 0.0
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.speed = speed
        self.startDelay = startDelay
    }
    
    var body: some View {
        Text(displayedText)
            .font(font)
            .foregroundColor(color)
            .onAppear {
                startTypewriterAnimation()
            }
            .onChange(of: text) { _, newText in
                resetAnimation()
                startTypewriterAnimation()
            }
    }
    
    private func startTypewriterAnimation() {
        displayedText = ""
        currentIndex = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
            animateNextCharacter()
        }
    }
    
    private func animateNextCharacter() {
        guard currentIndex < text.count else { return }
        
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        displayedText += String(text[index])
        currentIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
            animateNextCharacter()
        }
    }
    
    private func resetAnimation() {
        displayedText = ""
        currentIndex = 0
    }
}

// MARK: - Convenience Initializers

extension TypewriterText {
    /// Creates a typewriter text with theme styling
    static func themed(
        _ text: String,
        style: ThemeTextStyle = .body,
        color: Color? = nil,
        speed: TimeInterval = 0.05,
        startDelay: TimeInterval = 0.0
    ) -> TypewriterText {
        let themeFont: Font
        let themeColor = color ?? Theme.Colors.primaryText
        
        switch style {
        case .largeTitle:
            themeFont = Theme.Typography.largeTitle
        case .title:
            themeFont = Theme.Typography.title
        case .title2:
            themeFont = Theme.Typography.title2
        case .headline:
            themeFont = Theme.Typography.headline
        case .body:
            themeFont = Theme.Typography.body
        case .caption:
            themeFont = Theme.Typography.caption
        case .caption2:
            themeFont = Theme.Typography.caption2
        }
        
        return TypewriterText(
            text,
            font: themeFont,
            color: themeColor,
            speed: speed,
            startDelay: startDelay
        )
    }
}

// MARK: - Theme Text Styles

enum ThemeTextStyle {
    case largeTitle
    case title
    case title2
    case headline
    case body
    case caption
    case caption2
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        TypewriterText.themed(
            "Welcome to Messages",
            style: .largeTitle,
            color: Theme.Colors.primary
        )
        
        TypewriterText.themed(
            "What's your name?",
            style: .title2,
            color: Theme.Colors.secondaryText,
            speed: 0.08,
            startDelay: 2.0
        )
        
        TypewriterText(
            "This is a custom typewriter animation!",
            font: .headline,
            color: .blue,
            speed: 0.03
        )
    }
    .padding()
}
