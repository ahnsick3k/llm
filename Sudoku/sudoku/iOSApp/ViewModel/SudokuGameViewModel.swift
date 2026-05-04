import Foundation
import Combine

@MainActor
final class SudokuGameViewModel: ObservableObject {
    @Published private(set) var cells: [SudokuCellState] = []
    @Published private(set) var mistakes: Int = 0
    @Published private(set) var maxMistakes: Int = 3

    @Published var selectedCoordinate: CellCoordinate?
    @Published var isNoteMode: Bool = false

    let numbers: [Int] = Array(1...9)

    private let adapter: SudokuGameAdapting

    init(adapter: SudokuGameAdapting? = nil) {
        self.adapter = adapter ?? Self.makeDefaultAdapter()
        reloadFromAdapter()
    }

    var boardRows: [[SudokuCellState]] {
        let size = adapter.boardSize
        return stride(from: 0, to: cells.count, by: size).map {
            Array(cells[$0..<$0 + size])
        }
    }

    var heartsRemaining: Int {
        max(0, maxMistakes - mistakes)
    }

    var selectedValue: Int? {
        guard let selectedCoordinate else { return nil }
        return value(at: selectedCoordinate)
    }

    func select(_ coordinate: CellCoordinate) {
        selectedCoordinate = coordinate
        adapter.selectCell(at: coordinate)
        rebuildHighlights()
    }

    func input(number: Int) {
        guard let selectedCoordinate else { return }
        adapter.enter(value: number, at: selectedCoordinate, asNote: isNoteMode)
        reloadFromAdapter()
    }

    func erase() {
        guard let selectedCoordinate else { return }
        adapter.eraseValue(at: selectedCoordinate)
        reloadFromAdapter()
    }

    func hint() {
        guard let selectedCoordinate else { return }
        adapter.requestHint(at: selectedCoordinate)
        reloadFromAdapter()
    }

    func restart() {
        adapter.restart()
        selectedCoordinate = nil
        reloadFromAdapter()
    }

    private func reloadFromAdapter() {
        mistakes = adapter.mistakes
        maxMistakes = adapter.maxMistakes

        var nextCells: [SudokuCellState] = []
        nextCells.reserveCapacity(adapter.boardSize * adapter.boardSize)

        for row in 0..<adapter.boardSize {
            for col in 0..<adapter.boardSize {
                let coordinate = CellCoordinate(row: row, column: col)
                nextCells.append(
                    SudokuCellState(
                        coordinate: coordinate,
                        value: adapter.board[row][col],
                        notes: adapter.notes[coordinate] ?? [],
                        isGiven: adapter.givens.contains(coordinate),
                        highlights: []
                    )
                )
            }
        }

        cells = nextCells
        rebuildHighlights()
    }

    private func rebuildHighlights() {
        guard !cells.isEmpty else { return }

        let conflicts = adapter.conflicts
        let selectedValue = selectedCoordinate.flatMap(value(at:))

        var updated: [SudokuCellState] = []
        updated.reserveCapacity(cells.count)

        for var cell in cells {
            var highlights: Set<SudokuCellHighlight> = []

            if let selectedCoordinate {
                if cell.coordinate == selectedCoordinate {
                    highlights.insert(.selected)
                } else if isRelated(to: selectedCoordinate, other: cell.coordinate) {
                    highlights.insert(.relatedGroup)
                }

                if let selectedValue,
                   cell.value == selectedValue,
                   cell.coordinate != selectedCoordinate {
                    highlights.insert(.sameValue)
                }
            }

            if conflicts.contains(cell.coordinate) {
                highlights.insert(.conflict)
            }

            cell.highlights = highlights
            updated.append(cell)
        }

        cells = updated
    }

    private func isRelated(to selected: CellCoordinate, other: CellCoordinate) -> Bool {
        selected.row == other.row ||
        selected.column == other.column ||
        selected.boxIndex == other.boxIndex
    }

    private func value(at coordinate: CellCoordinate) -> Int? {
        guard
            coordinate.row >= 0,
            coordinate.row < adapter.board.count,
            coordinate.column >= 0,
            coordinate.column < adapter.board[coordinate.row].count
        else {
            return nil
        }

        return adapter.board[coordinate.row][coordinate.column]
    }

    private static func makeDefaultAdapter() -> SudokuGameAdapting {
#if canImport(SudokuCore)
        return LiveSudokuCoreAdapter()
#else
        return MockSudokuAdapter()
#endif
    }
}
