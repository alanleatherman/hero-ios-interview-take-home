import SwiftUI

struct PurpleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(Theme.Colors.primaryText)
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                    .fill(Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                            .stroke(Theme.Colors.primary.opacity(0.3), lineWidth: 1)
                    )
            )
            .accentColor(Theme.Colors.primary)
            .themeShadow(Theme.Shadows.light)
    }
}
