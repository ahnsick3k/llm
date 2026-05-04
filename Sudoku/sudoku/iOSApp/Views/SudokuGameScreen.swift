import SwiftUI
import UIKit

@MainActor
struct SudokuGameScreen: View {
    @StateObject private var viewModel: SudokuGameViewModel
    @FocusState private var isKeyboardFocused: Bool
    @State private var keyboardBuffer = ""
    @State private var showMenu = false
    @State private var showShop = false

    @MainActor
    init(viewModel: SudokuGameViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? SudokuGameViewModel())
    }

    var body: some View {
        GeometryReader { proxy in
            let sidePadding = max(16, proxy.size.width * 0.05)
            let maxBoardWidth = min(proxy.size.width - (sidePadding * 2), 520)

            ZStack(alignment: .topLeading) {
                // Background tap area — dismisses keyboard and selection
                SudokuTheme.backgroundGradient
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture { dismissKeyboardAndSelection() }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        SudokuTopBarView(
                            compact: false,
                            onMenu: { showMenu = true },
                            onShop: { showShop = true }
                        )

                        SudokuBoardView(rows: viewModel.boardRows) { coordinate in
                            viewModel.select(coordinate)
                            isKeyboardFocused = true
                        }
                        .frame(maxWidth: maxBoardWidth)

                        SudokuStatusBarView(
                            maxMistakes: viewModel.maxMistakes,
                            heartsRemaining: viewModel.heartsRemaining
                        )
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 14)
                    .padding(.bottom, 28)
                }
                // Hidden TextField — provides system keyboard
                TextField("", text: $keyboardBuffer)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isKeyboardFocused)
                    .frame(width: 1, height: 1)
                    .opacity(0.01)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    keyboardDock
                }
            }
            .onChange(of: viewModel.selectedCoordinate) { _, coordinate in
                if coordinate == nil {
                    isKeyboardFocused = false
                    keyboardBuffer = ""
                }
            }
            .onChange(of: keyboardBuffer) { _, newValue in
                guard !newValue.isEmpty else { return }
                defer { keyboardBuffer = "" }
                guard let last = newValue.last, let digit = last.wholeNumberValue else { return }
                guard (1...9).contains(digit) else { return }
                viewModel.input(number: digit)
            }
            .font(SudokuTheme.Typography.body)
        }
        .sheet(isPresented: $showMenu) { SudokuMenuView() }
        .sheet(isPresented: $showShop) { SudokuShopView() }
    }

    private var keyboardDock: some View {
        HStack(spacing: 8) {
            modeButton(title: "Entry", active: !viewModel.isNoteMode) {
                viewModel.isNoteMode = false
            }
            modeButton(title: "Notes", active: viewModel.isNoteMode) {
                viewModel.isNoteMode = true
            }

            Spacer(minLength: 8)

            iconButton(symbol: "lightbulb", action: viewModel.hint)
            iconButton(symbol: "eraser", action: viewModel.erase)
            iconButton(symbol: "arrow.counterclockwise", action: viewModel.restart)
        }
    }

    private func modeButton(title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(SudokuTheme.Typography.modeLabel)
                .foregroundStyle(active ? Color.white : SudokuTheme.givenText)
                .frame(minWidth: 60, minHeight: 40)
                .padding(.horizontal, 6)
                .background(active ? SudokuTheme.accent : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(SudokuTheme.panelBorder, lineWidth: active ? 0 : 1)
                }
        }
        .buttonStyle(.plain)
    }

    private func iconButton(symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(SudokuTheme.Typography.toolIcon)
                .foregroundStyle(SudokuTheme.accent)
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(SudokuTheme.panelBorder, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private func dismissKeyboardAndSelection() {
        isKeyboardFocused = false
        viewModel.deselect()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SudokuGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        SudokuGameScreen()
    }
}
