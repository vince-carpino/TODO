import SwiftUI

struct FormattedText: ViewModifier {
    let fontSize: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
    }
}

extension View {
    func formatted(fontSize: CGFloat, foregroundColor: Color = .clouds) -> some View {
        modifier(FormattedText(fontSize: fontSize, color: foregroundColor))
    }
}
