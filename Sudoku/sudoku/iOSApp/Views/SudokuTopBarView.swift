import SwiftUI

struct SudokuTopBarView: View {
    var body: some View {
        HStack(spacing: 16) {
            actionButton(symbol: "line.3.horizontal")

            VStack(spacing: 2) {
                Text("Beautiful")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(SudokuTheme.mutedText)
                Text("Sudoku")
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(SudokuTheme.givenText)
            }

            Spacer(minLength: 8)

            actionButton(symbol: "cart.fill")
        }
    }

    private func actionButton(symbol: String) -> some View {
        Button(action: {}) {
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .bold))
                .frame(width: 48, height: 48)
                .foregroundStyle(SudokuTheme.accent)
                .background(SudokuTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SudokuTopBarView()
        .padding()
        .background(SudokuTheme.backgroundGradient)
}
