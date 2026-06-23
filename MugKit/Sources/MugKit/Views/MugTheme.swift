import SwiftUI

/// Minimal, monochrome styling shared across platforms. Deliberately sparse — the app should
/// feel like a quiet utility, not a dashboard product.
public enum MugTheme {
    public static let spacing: CGFloat = 16
    public static let cornerRadius: CGFloat = 12

    /// Neutral accent so the UI stays grayscale until the user does something meaningful.
    public static let accent = Color.primary
}

extension View {
    /// Standard row container used by the lists.
    func mugCard() -> some View {
        padding(MugTheme.spacing)
            .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: MugTheme.cornerRadius))
    }
}
