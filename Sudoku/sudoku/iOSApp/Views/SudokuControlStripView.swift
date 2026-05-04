import SwiftUI

struct SudokuControlStripView: View {
    let noteMode: Bool
    let onToggleNotes: () -> Void
    let onErase: () -> Void
    let onHint: () -> Void
    let onRestart: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            toolButton(
                title: noteMode ? "Notes On" : "Notes",
                symbol: noteMode ? "pencil.circle.fill" : "pencil.circle",
                emphasized: noteMode,
                action: onToggleNotes
            )

            toolButton(title: "Erase", symbol: "eraser.fill", action: onErase)
            toolButton(title: "Hint", symbol: "lightbulb.fill", action: onHint)
            toolButton(title: "Restart", symbol: "arrow.counterclockwise", action: onRestart)
        }
    }

    private func toolButton(
        title: String,
        symbol: String,
        emphasized: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.system(size: 18, weight: .bold))
                Text(title)
                    .font(.caption.weight(.bold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .foregroundStyle(emphasized ? Color.white : SudokuTheme.accent)
            .background(emphasized ? SudokuTheme.accent : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(SudokuTheme.thinGrid, lineWidth: emphasized ? 0 : 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SudokuControlStripView(noteMode: true, onToggleNotes: {}, onErase: {}, onHint: {}, onRestart: {})
        .padding()
        .background(SudokuTheme.backgroundGradient)
}
