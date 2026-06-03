import SwiftUI

// 所持している魚を一覧表示するView
struct BoxView: View {
    // 魚データを管理するViewModelを環境から取得
    @EnvironmentObject private var fishViewModel: FishViewModel
    @StateObject private var boxViewModel = BoxViewModel()

    // 3列表示用のグリッド設定
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    // 所持数が1以上の魚だけを表示対象に絞り込み
    private var ownedFishItems: [FishItemViewModel] {
        fishViewModel.fishItems.filter { $0.fishModel.ownedCount > 0 }
    }

    var body: some View {
        ScrollView {
            // 所持している魚を3列で並べる
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(ownedFishItems) { fishItem in
                    // 魚カードをボタンにする
                    Button {
                        boxViewModel.showFishDetail(fishItem: fishItem)
                    } label: {
                        FishBoxItemView(fishItem: fishItem)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .navigationTitle("Box")
        .sheet(item: $boxViewModel.selectedFishItem, onDismiss: {
            boxViewModel.dismissFishDetail()
        }) { fishItem in
            FishBoxDetailView(fishItem: fishItem)
        }
    }
}

// 魚1匹分の表示View
private struct FishBoxItemView: View {
    @ObservedObject var fishItem: FishItemViewModel

    // 表示用の固定魚データをfishIDから取得
    private var fishData: FishStruct? {
        allFish.fish(for: fishItem.id)
    }

    var body: some View {
        VStack(spacing: 8) {
            if let fishData {
                // 魚画像
                fishData.image2
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 74)
            }

            // 所持数
            Text("x\(fishItem.ownedCountText)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary.opacity(0.25), lineWidth: 1)
        }
    }
}

// 魚詳細表示View
private struct FishBoxDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var fishItem: FishItemViewModel

    // 表示用の固定魚データをfishIDから取得
    private var fishData: FishStruct? {
        allFish.fish(for: fishItem.id)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss()
                    }

                VStack(spacing: 24) {
                    if let fishData {
                        fishData.image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: CGFloat(fishData.portraitSize) * 0.25)
                            .padding(.top, 24)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        FishBoxDetailRowView(title: "Name", value: fishItem.nameText)
                        FishBoxDetailRowView(title: "Owned", value: "x\(fishItem.ownedCountText)")
                        FishBoxDetailRowView(title: "First obtained", value: fishItem.firstObtainedAtText)
                    }
                    .padding(16)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary.opacity(0.25), lineWidth: 1)
                    }
                    .onTapGesture { }

                    Spacer()
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(fishItem.nameText)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 魚詳細Viewの1行分
private struct FishBoxDetailRowView: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 16)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}
