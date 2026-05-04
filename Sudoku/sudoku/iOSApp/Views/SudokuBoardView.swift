import SwiftUI

struct SudokuBoardView: View {
    let rows: [[SudokuCellState]]
    let onTapCell: (CellCoordinate) -> Void

    var body: some View {
        GeometryReader { proxy in
            let rawSide = min(proxy.size.width, proxy.size.height)
            let cellSide = floor(rawSide / 9)
            let boardSide = cellSide * 9
            let flattened = rows.flatMap { $0 }

            ZStack(alignment: .topLeading) {
                SudokuTheme.cell
                    .frame(width: boardSide, height: boardSide)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(cellSide), spacing: 0), count: 9),
                    spacing: 0
                ) {
                    ForEach(flattened) { cell in
                        SudokuCellView(cell: cell, cellSide: cellSide)
                            .frame(width: cellSide, height: cellSide)
                            .contentShape(Rectangle())
                            .onTapGesture { onTapCell(cell.coordinate) }
                    }
                }
                .frame(width: boardSide, height: boardSide)

                SudokuBoardGridOverlay(side: boardSide, cellSide: cellSide)
                    .frame(width: boardSide, height: boardSide)
                    .allowsHitTesting(false)
            }
            .frame(width: boardSide, height: boardSide)
            .clipped()
            .mask(RoundedRectangle(cornerRadius: 2, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .stroke(SudokuTheme.boardBorder, lineWidth: 2.0)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct SudokuCellView: View {
    let cell: SudokuCellState
    let cellSide: CGFloat

    var body: some View {
        ZStack {
            cellBackground
            if let value = cell.value {
                Text("\(value)")
                    .font(SudokuTheme.Typography.boardValue.weight(cell.isGiven ? .medium : .regular))
                    .foregroundStyle(cell.isGiven ? SudokuTheme.givenText : SudokuTheme.userText)
            } else if !cell.notes.isEmpty {
                SudokuNotesView(notes: cell.notes, cellSide: cellSide)
            }
        }
    }

    private var cellBackground: some View {
        Group {
            if cell.highlights.contains(.conflict) {
                SudokuTheme.conflict
            } else if cell.highlights.contains(.selected) {
                SudokuTheme.selected
            } else if cell.highlights.contains(.sameValue) {
                SudokuTheme.sameValue
            } else if cell.highlights.contains(.relatedGroup) {
                SudokuTheme.related
            } else {
                SudokuTheme.cell
            }
        }
    }
}

private struct SudokuNotesView: View {
    let notes: Set<Int>
    let cellSide: CGFloat

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        let noteFontSize = max(7, floor(cellSide / 4.5))
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(1...9, id: \.self) { value in
                Text(notes.contains(value) ? "\(value)" : " ")
                    .font(.system(size: noteFontSize, weight: .regular))
                    .foregroundStyle(SudokuTheme.noteText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .lineLimit(1)
            }
        }
        .frame(width: cellSide, height: cellSide)
    }
}

private struct SudokuBoardGridOverlay: View {
    let side: CGFloat
    let cellSide: CGFloat

    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                let thickness: CGFloat = index.isMultiple(of: 3) ? 2.0 : 0.7
                let offset = CGFloat(index) * cellSide

                Path { path in
                    path.move(to: CGPoint(x: offset, y: 0))
                    path.addLine(to: CGPoint(x: offset, y: side))
                }
                .stroke(SudokuTheme.boardBorder.opacity(index.isMultiple(of: 3) ? 0.78 : 0.22), lineWidth: thickness)

                Path { path in
                    path.move(to: CGPoint(x: 0, y: offset))
                    path.addLine(to: CGPoint(x: side, y: offset))
                }
                .stroke(SudokuTheme.boardBorder.opacity(index.isMultiple(of: 3) ? 0.78 : 0.22), lineWidth: thickness)
            }
        }
    }
}

struct SudokuBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuBoardView(rows: [], onTapCell: { _ in })
            .padding()
            .frame(height: 420)
            .background(SudokuTheme.backgroundGradient)
    }
}
