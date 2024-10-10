import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat) -> some View {
        self.modifier(CornerRadiusStyle(radius: radius))
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat = 8.0

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}
