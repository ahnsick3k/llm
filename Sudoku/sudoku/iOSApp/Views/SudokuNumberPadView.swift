import SwiftUI

struct SudokuNumberPadView: View {
    let selectedValue: Int?
    let onTap: (Int) -> Void

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1...9, id: \.self) { value in
                Button {
                    onTap(value)
                } label: {
                    Text("\(value)")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .frame(height: 62)
                        .foregroundStyle(selectedValue == value ? Color.white : SudokuTheme.accent)
                        .background(selectedValue == value ? SudokuTheme.accent : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .stroke(SudokuTheme.thinGrid, lineWidth: selectedValue == value ? 0 : 1)
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    SudokuNumberPadView(selectedValue: 5, onTap: { _ in })
        .padding()
        .background(SudokuTheme.backgroundGradient)
}
