import SwiftUI

struct SudokuStatusBarView: View {
    let maxMistakes: Int
    let heartsRemaining: Int

    var body: some View {
        HStack {
            Text("Mistakes")
                .font(SudokuTheme.Typography.label)
                .foregroundStyle(SudokuTheme.mutedText)

            Spacer()

            HStack(spacing: 5) {
                ForEach(0..<maxMistakes, id: \.self) { index in
                    Image(systemName: index < heartsRemaining ? "heart.fill" : "heart")
                        .foregroundStyle(index < heartsRemaining ? Color.red : Color.red.opacity(0.3))
                        .font(.system(size: 22, weight: .light))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(SudokuTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(SudokuTheme.panelBorder, lineWidth: 1)
        }
    }
}

struct SudokuStatusBarView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuStatusBarView(maxMistakes: 3, heartsRemaining: 2)
            .padding()
            .background(SudokuTheme.backgroundGradient)
    }
}
