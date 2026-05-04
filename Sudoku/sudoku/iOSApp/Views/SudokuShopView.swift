import SwiftUI

struct SudokuShopView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = SudokuScoreStore.shared
    @State private var purchasedFeedback: String? = nil

    var body: some View {
        NavigationStack {
            List {
                // Score header
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("보유 점수")
                                .font(SudokuTheme.Typography.label)
                                .foregroundStyle(SudokuTheme.mutedText)
                            Text("\(store.score)점")
                                .font(.system(size: 28, weight: .light))
                                .foregroundStyle(SudokuTheme.givenText)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("환산 금액")
                                .font(SudokuTheme.Typography.label)
                                .foregroundStyle(SudokuTheme.mutedText)
                            Text("\(store.won)원")
                                .font(.system(size: 28, weight: .light))
                                .foregroundStyle(SudokuTheme.accent)
                        }
                    }
                    .padding(.vertical, 4)

                    Text("100점 = 1원 · 1게임 클리어 = 1,000점")
                        .font(SudokuTheme.Typography.label)
                        .foregroundStyle(SudokuTheme.mutedText)
                }

                if let feedback = purchasedFeedback {
                    Section {
                        Label(feedback, systemImage: "checkmark.circle.fill")
                            .font(SudokuTheme.Typography.body)
                            .foregroundStyle(.green)
                    }
                }

                Section("아이템") {
                    ForEach(store.items) { item in
                        shopRow(item)
                    }
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(SudokuTheme.Typography.label)
                }
            }
        }
    }

    private func shopRow(_ item: ShopItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.symbol)
                .font(.system(size: 22, weight: .light))
                .foregroundStyle(SudokuTheme.accent)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(SudokuTheme.Typography.body)
                    .foregroundStyle(SudokuTheme.givenText)
                Text(item.description)
                    .font(SudokuTheme.Typography.label)
                    .foregroundStyle(SudokuTheme.mutedText)
            }

            Spacer()

            if store.isPurchased(item) {
                Text("보유 중")
                    .font(SudokuTheme.Typography.label)
                    .foregroundStyle(SudokuTheme.mutedText)
            } else {
                Button {
                    if store.purchase(item) {
                        purchasedFeedback = "\(item.title) 구매 완료!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            purchasedFeedback = nil
                        }
                    }
                } label: {
                    Text("\(item.price)점")
                        .font(SudokuTheme.Typography.label)
                        .foregroundStyle(store.score >= item.price ? .white : SudokuTheme.mutedText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(store.score >= item.price ? SudokuTheme.accent : SudokuTheme.panelBorder)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(store.score < item.price)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SudokuShopView()
}
