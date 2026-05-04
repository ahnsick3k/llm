import Foundation
#if canImport(SudokuCore)
import SudokuCore
#endif

struct CellCoordinate: Hashable, Identifiable {
    let row: Int
    let column: Int

    var id: String { "\(row)-\(column)" }

    var boxIndex: Int {
        (row / 3) * 3 + (column / 3)
    }
}

enum SudokuCellHighlight: Hashable {
    case selected
    case relatedGroup
    case sameValue
    case conflict
}

struct SudokuCellState: Identifiable {
    let coordinate: CellCoordinate
    var value: Int?
    var notes: Set<Int>
    var isGiven: Bool
    var highlights: Set<SudokuCellHighlight>

    var id: String { coordinate.id }
}

protocol SudokuGameAdapting: AnyObject {
    var boardSize: Int { get }
    var maxMistakes: Int { get }
    var mistakes: Int { get }

    var board: [[Int?]] { get }
    var givens: Set<CellCoordinate> { get }
    var notes: [CellCoordinate: Set<Int>] { get }
    var conflicts: Set<CellCoordinate> { get }

    func selectCell(at coordinate: CellCoordinate)
    func enter(value: Int, at coordinate: CellCoordinate, asNote: Bool)
    func eraseValue(at coordinate: CellCoordinate)
    func requestHint(at coordinate: CellCoordinate)
    func restart()
}

final class MockSudokuAdapter: SudokuGameAdapting {
    private let initialBoard: [[Int?]] = [
        [5, 3, nil, nil, 7, nil, nil, nil, nil],
        [6, nil, nil, 1, 9, 5, nil, nil, nil],
        [nil, 9, 8, nil, nil, nil, nil, 6, nil],
        [8, nil, nil, nil, 6, nil, nil, nil, 3],
        [4, nil, nil, 8, nil, 3, nil, nil, 1],
        [7, nil, nil, nil, 2, nil, nil, nil, 6],
        [nil, 6, nil, nil, nil, nil, 2, 8, nil],
        [nil, nil, nil, 4, 1, 9, nil, nil, 5],
        [nil, nil, nil, nil, 8, nil, nil, 7, 9]
    ]

    private let solution: [[Int]] = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9]
    ]

    var boardSize: Int { 9 }
    var maxMistakes: Int { 3 }
    private(set) var mistakes: Int = 0

    private(set) var board: [[Int?]]
    private(set) var notes: [CellCoordinate: Set<Int>] = [:]
    private(set) var conflicts: Set<CellCoordinate> = []

    lazy var givens: Set<CellCoordinate> = {
        var set = Set<CellCoordinate>()
        for row in 0..<9 {
            for col in 0..<9 where initialBoard[row][col] != nil {
                set.insert(CellCoordinate(row: row, column: col))
            }
        }
        return set
    }()

    init() {
        board = initialBoard
    }

    func selectCell(at coordinate: CellCoordinate) {
        _ = coordinate
    }

    func enter(value: Int, at coordinate: CellCoordinate, asNote: Bool) {
        guard !givens.contains(coordinate) else { return }

        if asNote {
            var current = notes[coordinate] ?? []
            if current.contains(value) {
                current.remove(value)
            } else {
                current.insert(value)
            }
            notes[coordinate] = current
            return
        }

        notes[coordinate] = []
        board[coordinate.row][coordinate.column] = value

        if solution[coordinate.row][coordinate.column] != value {
            mistakes += 1
            conflicts.insert(coordinate)
        } else {
            conflicts.remove(coordinate)
        }
    }

    func eraseValue(at coordinate: CellCoordinate) {
        guard !givens.contains(coordinate) else { return }
        board[coordinate.row][coordinate.column] = nil
        notes[coordinate] = []
        conflicts.remove(coordinate)
    }

    func requestHint(at coordinate: CellCoordinate) {
        guard !givens.contains(coordinate) else { return }
        board[coordinate.row][coordinate.column] = solution[coordinate.row][coordinate.column]
        notes[coordinate] = []
        conflicts.remove(coordinate)
    }

    func restart() {
        board = initialBoard
        notes = [:]
        conflicts = []
        mistakes = 0
    }
}

#if canImport(SudokuCore)
final class LiveSudokuCoreAdapter: SudokuGameAdapting {
    var boardSize: Int { 9 }
    var maxMistakes: Int { maxAllowedMistakes }
    var mistakes: Int { max(0, maxAllowedMistakes - game.remainingHearts) }

    var board: [[Int?]] {
        stride(from: 0, to: game.cells.count, by: boardSize).map { start in
            game.cells[start..<(start + boardSize)].map(\.value)
        }
    }

    var givens: Set<CellCoordinate> {
        Set(game.cells.filter(\.isFixed).map { Self.coordinate(for: $0.index) })
    }

    var notes: [CellCoordinate: Set<Int>] {
        var mapped: [CellCoordinate: Set<Int>] = [:]
        for cell in game.cells where !cell.notes.isEmpty {
            mapped[Self.coordinate(for: cell.index)] = cell.notes
        }
        return mapped
    }

    private(set) var conflicts: Set<CellCoordinate> = []

    private let difficulty: Difficulty
    private let maxAllowedMistakes: Int
    private var game: SudokuGame

    init(difficulty: Difficulty = .medium, maxMistakes: Int = 3) {
        self.difficulty = difficulty
        self.maxAllowedMistakes = max(0, maxMistakes)
        self.game = Self.makeInitialGame(difficulty: difficulty, hearts: max(0, maxMistakes))
    }

    func selectCell(at coordinate: CellCoordinate) {
        game.selectCell(at: Self.index(for: coordinate))
    }

    func enter(value: Int, at coordinate: CellCoordinate, asNote: Bool) {
        guard let index = Self.index(for: coordinate) else { return }

        let previousHearts = game.remainingHearts
        game.setInputMode(asNote ? .note : .normal)
        game.applyInput(value, at: index)

        if !asNote {
            if game.remainingHearts < previousHearts {
                conflicts.insert(coordinate)
            } else if game.cells[index].value != nil {
                conflicts.remove(coordinate)
            }
        }
    }

    func eraseValue(at coordinate: CellCoordinate) {
        guard let index = Self.index(for: coordinate) else { return }
        game.clearCell(at: index)
        conflicts.remove(coordinate)
    }

    func requestHint(at coordinate: CellCoordinate) {
        guard let index = Self.index(for: coordinate) else { return }
        guard !game.cells[index].isFixed else { return }

        let previousMode = game.inputMode
        let solutionValue = game.puzzle.solution[index]
        game.setInputMode(.normal)
        game.applyInput(solutionValue, at: index)
        game.setInputMode(previousMode)
        conflicts.remove(coordinate)
    }

    func restart() {
        game = Self.makeInitialGame(difficulty: difficulty, hearts: maxAllowedMistakes)
        conflicts = []
    }

    private static func makeInitialGame(difficulty: Difficulty, hearts: Int) -> SudokuGame {
        if let puzzle = try? SudokuPuzzleLibrary.randomPuzzle(for: difficulty) {
            return SudokuGame(puzzle: puzzle, startingHearts: hearts)
        }

        let fallback: [Int] = [
            5, 3, 0, 0, 7, 0, 0, 0, 0,
            6, 0, 0, 1, 9, 5, 0, 0, 0,
            0, 9, 8, 0, 0, 0, 0, 6, 0,
            8, 0, 0, 0, 6, 0, 0, 0, 3,
            4, 0, 0, 8, 0, 3, 0, 0, 1,
            7, 0, 0, 0, 2, 0, 0, 0, 6,
            0, 6, 0, 0, 0, 0, 2, 8, 0,
            0, 0, 0, 4, 1, 9, 0, 0, 5,
            0, 0, 0, 0, 8, 0, 0, 7, 9
        ]
        let solved: [Int] = [
            5, 3, 4, 6, 7, 8, 9, 1, 2,
            6, 7, 2, 1, 9, 5, 3, 4, 8,
            1, 9, 8, 3, 4, 2, 5, 6, 7,
            8, 5, 9, 7, 6, 1, 4, 2, 3,
            4, 2, 6, 8, 5, 3, 7, 9, 1,
            7, 1, 3, 9, 2, 4, 8, 5, 6,
            9, 6, 1, 5, 3, 7, 2, 8, 4,
            2, 8, 7, 4, 1, 9, 6, 3, 5,
            3, 4, 5, 2, 8, 6, 1, 7, 9
        ]
        do {
            let puzzle = try SudokuPuzzle(difficulty: difficulty, givens: fallback, solution: solved)
            return SudokuGame(puzzle: puzzle, startingHearts: hearts)
        } catch {
            fatalError("Static fallback puzzle should be valid: \(error)")
        }
    }

    private static func index(for coordinate: CellCoordinate) -> Int? {
        guard (0..<9).contains(coordinate.row), (0..<9).contains(coordinate.column) else {
            return nil
        }
        return (coordinate.row * 9) + coordinate.column
    }

    private static func coordinate(for index: Int) -> CellCoordinate {
        CellCoordinate(row: index / 9, column: index % 9)
    }
}
#else
final class LiveSudokuCoreAdapter: SudokuGameAdapting {
    private let mock = MockSudokuAdapter()

    var boardSize: Int { mock.boardSize }
    var maxMistakes: Int { mock.maxMistakes }
    var mistakes: Int { mock.mistakes }
    var board: [[Int?]] { mock.board }
    var givens: Set<CellCoordinate> { mock.givens }
    var notes: [CellCoordinate: Set<Int>] { mock.notes }
    var conflicts: Set<CellCoordinate> { mock.conflicts }

    func selectCell(at coordinate: CellCoordinate) { mock.selectCell(at: coordinate) }
    func enter(value: Int, at coordinate: CellCoordinate, asNote: Bool) { mock.enter(value: value, at: coordinate, asNote: asNote) }
    func eraseValue(at coordinate: CellCoordinate) { mock.eraseValue(at: coordinate) }
    func requestHint(at coordinate: CellCoordinate) { mock.requestHint(at: coordinate) }
    func restart() { mock.restart() }
}
#endif
