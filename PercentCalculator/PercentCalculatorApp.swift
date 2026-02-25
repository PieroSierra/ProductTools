import SwiftUI

// MARK: - Liquid Glass Extensions (macOS Tahoe support)

extension View {
    /// Applies .glass button style on macOS 26+, falling back to .bordered.
    @ViewBuilder
    func percentCalcGlassButton() -> some View {
        if #available(macOS 26.0, *) {
            AnyView(self.buttonStyle(.glass))
        } else {
            AnyView(self.buttonStyle(.bordered))
        }
    }

    /// Applies Liquid Glass distortion effect on macOS 26+ (Tahoe),
    /// falling back to thin material blur on earlier systems.
    @ViewBuilder
    func percentCalcGlassEffect(cornerRadius: CGFloat = 16) -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            self.background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

@main
struct PercentCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color(nsColor: .windowBackgroundColor))
        }
        .windowToolbarStyle(.unified)
        .defaultSize(width: 700, height: 310)
    }
}
