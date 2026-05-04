import SwiftUI

enum SudokuTheme {
    // Meta-inspired color system with Apple-native typography usage.
    static let backgroundTop = Color(red: 0.969, green: 0.973, blue: 0.980) // #F7F8FA
    static let backgroundBottom = Color(red: 0.910, green: 0.953, blue: 1.000) // #E8F3FF

    static let panel = Color.white.opacity(0.94)
    static let boardBorder = Color(red: 0.110, green: 0.169, blue: 0.200) // #1C2B33
    static let thinGrid = Color(red: 0.871, green: 0.890, blue: 0.914) // #DEE3E9

    static let cell = Color.white
    static let related = Color(red: 0.945, green: 0.957, blue: 0.969) // #F1F4F7
    static let selected = Color(red: 0.851, green: 0.910, blue: 1.000) // #D9E8FF
    static let sameValue = Color(red: 0.910, green: 0.953, blue: 1.000) // #E8F3FF
    static let conflict = Color(red: 1.000, green: 0.902, blue: 0.922) // #FFE6EB

    static let givenText = Color(red: 0.110, green: 0.169, blue: 0.200) // #1C2B33
    static let userText = Color(red: 0.000, green: 0.392, blue: 0.878) // #0064E0
    static let noteText = Color(red: 0.365, green: 0.424, blue: 0.482) // #5D6C7B

    static let accent = Color(red: 0.000, green: 0.392, blue: 0.878) // #0064E0
    static let accentPressed = Color(red: 0.000, green: 0.294, blue: 0.725) // #004BB9
    static let mutedText = Color(red: 0.396, green: 0.404, blue: 0.420) // #65676B

    enum Typography {
        // Keep the app on SF Pro / system stack for iOS-native clarity.
        static let title = Font.system(size: 28, weight: .heavy, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let label = Font.system(size: 13, weight: .semibold, design: .default)
        static let boardValue = Font.system(size: 27, weight: .bold, design: .rounded)
        static let boardNote = Font.system(size: 9, weight: .semibold, design: .rounded)
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
