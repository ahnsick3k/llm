import SwiftUI

struct SudokuHomeScreen: View {
    @State private var selectedDifficulty: SudokuDifficulty = .medium
    @State private var showGame = false
    @State private var blurRadius: CGFloat = 7
    @State private var boardOpacity: Double = 1.0

    var body: some View {
        ZStack {
            // Background: blurred board changes with difficulty
            GeometryReader { proxy in
                SudokuBoardView(rows: boardRows(for: selectedDifficulty)) { _ in }
                    .frame(width: proxy.size.width, height: proxy.size.width)
                    .position(x: proxy.size.width / 2, y: proxy.size.height * 0.38)
                    .blur(radius: blurRadius)
                    .opacity(boardOpacity)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()

            LinearGradient(
                colors: [Color.black.opacity(0.22), Color.black.opacity(0.58)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Title
                VStack(spacing: 6) {
                    Text("Beautiful")
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(.white.opacity(0.85))
                        .tracking(4)
                    Text("Sudoku")
                        .font(.system(size: 56, weight: .ultraLight))
                        .foregroundStyle(.white)
                }
                .padding(.top, 88)

                Spacer()

                // Control card
                VStack(spacing: 16) {
                    Text("난이도 선택")
                        .font(.system(size: 15, weight: .light))
                        .foregroundStyle(.white.opacity(0.75))

                    // Wheel spinner
                    Picker("", selection: $selectedDifficulty) {
                        ForEach(SudokuDifficulty.allCases) { d in
                            Text(d.rawValue)
                                .font(.system(size: 24, weight: .light))
                                .tag(d)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                    .colorScheme(.dark)
                    .onChange(of: selectedDifficulty) { _, _ in
                        withAnimation(.easeOut(duration: 0.18)) { boardOpacity = 0 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                            withAnimation(.easeIn(duration: 0.25)) { boardOpacity = 1 }
                        }
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) { blurRadius = 0 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showGame = true
                        }
                    } label: {
                        Text("Game Start")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(SudokuTheme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .colorScheme(.dark)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.horizontal, 20)
                .padding(.bottom, 52)
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showGame) {
            blurRadius = 7
            boardOpacity = 1
        } content: {
            SudokuGameScreen(difficulty: selectedDifficulty)
        }
    }

    // MARK: - Board per difficulty

    private func boardRows(for difficulty: SudokuDifficulty) -> [[SudokuCellState]] {
        let raw: [[Int?]]
        switch difficulty {
        case .easy:   raw = Self.easyBoard
        case .medium: raw = Self.mediumBoard
        case .hard:   raw = Self.hardBoard
        case .expert: raw = Self.expertBoard
        }
        return raw.enumerated().map { r, row in
            row.enumerated().map { c, value in
                SudokuCellState(
                    coordinate: CellCoordinate(row: r, column: c),
                    value: value,
                    notes: [],
                    isGiven: value != nil,
                    highlights: []
                )
            }
        }
    }

    // Easy: ~63 filled (many numbers visible)
    private static let easyBoard: [[Int?]] = [
        [5, 3, 4, nil, 7, 8, nil, 1, 2],
        [6, nil, 2, 1, 9, nil, 3, 4, 8],
        [nil, 9, 8, 3, nil, 2, 5, nil, 7],
        [8, 5, nil, 7, 6, 1, nil, 2, 3],
        [4, nil, 6, 8, 5, nil, 7, 9, 1],
        [7, 1, nil, 9, 2, 4, nil, 5, 6],
        [9, 6, 1, nil, 3, 7, 2, nil, 4],
        [2, nil, 7, 4, 1, 9, nil, 3, 5],
        [3, 4, 5, nil, 8, 6, 1, nil, 9]
    ]

    // Medium: ~36 filled (balanced)
    private static let mediumBoard: [[Int?]] = [
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

    // Hard: ~20 filled (sparse)
    private static let hardBoard: [[Int?]] = [
        [5, nil, nil, nil, nil, 8, nil, nil, nil],
        [nil, 7, nil, 1, nil, nil, nil, nil, 8],
        [nil, nil, 8, nil, nil, nil, nil, 6, nil],
        [nil, nil, nil, 7, nil, nil, nil, nil, 3],
        [nil, nil, 6, nil, nil, 3, nil, nil, nil],
        [7, nil, nil, nil, 2, nil, nil, nil, nil],
        [nil, 6, nil, nil, nil, nil, 2, nil, nil],
        [nil, nil, nil, 4, nil, 9, nil, nil, nil],
        [nil, nil, nil, nil, 8, nil, nil, 7, nil]
    ]

    // Expert: ~10 filled (very sparse)
    private static let expertBoard: [[Int?]] = [
        [nil, nil, nil, nil, 7, nil, nil, nil, nil],
        [nil, 7, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, 8, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, 7, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, 3, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, 8, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, 8, nil],
        [nil, nil, nil, 4, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, 8, nil, nil, nil, 9]
    ]
}

#Preview {
    SudokuHomeScreen()
}
