import SwiftUI

struct SudokuMenuView: View {
    @Environment(\.dismiss) private var dismiss
    let onNewGame: () -> Void
    let onRestart: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    menuRow(symbol: "plus.circle", title: "New Game") {
                        dismiss()
                        onNewGame()
                    }
                    menuRow(symbol: "arrow.counterclockwise", title: "Restart Game") {
                        dismiss()
                        onRestart()
                    }
                }
                Section("Difficulty") {
                    menuRow(symbol: "1.circle", title: "Easy") { dismiss() }
                    menuRow(symbol: "2.circle", title: "Medium") { dismiss() }
                    menuRow(symbol: "3.circle", title: "Hard") { dismiss() }
                    menuRow(symbol: "4.circle", title: "Expert") { dismiss() }
                }
                Section {
                    menuRow(symbol: "gearshape", title: "Settings") { dismiss() }
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(SudokuTheme.Typography.label)
                }
            }
        }
    }

    private func menuRow(symbol: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: symbol)
                .font(SudokuTheme.Typography.body)
                .foregroundStyle(SudokuTheme.givenText)
        }
    }
}

#Preview {
    SudokuMenuView(onNewGame: {}, onRestart: {})
}
