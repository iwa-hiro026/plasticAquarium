import Combine
import Foundation

// 獲得バナーに表示する魚カードの情報
struct BannerFishItem: Identifiable {
    let id: String
    let fish: FishStruct
    let count: Int
}

// 魚獲得時の帯状バナーを管理するViewModel
final class BannerViewModel: ObservableObject {
    @Published var showingBanner: Bool
    @Published var fishItems: [BannerFishItem]

    init() {
        showingBanner = false
        fishItems = []
    }

    // 獲得した魚をカード表示用にまとめてバナーを表示する
    func showBanner(fishes: [FishStruct]) {
        fishItems = groupedFishItems(from: fishes)
        showingBanner = !fishItems.isEmpty
    }

    // バナーを閉じて表示内容を消す
    func closeBanner() {
        showingBanner = false
        fishItems = []
    }

    // 同じ魚が複数ある場合は1枚のカードにまとめる
    private func groupedFishItems(from fishes: [FishStruct]) -> [BannerFishItem] {
        let groupedFishes = Dictionary(grouping: fishes, by: \.id)

        return groupedFishes.compactMap { fishID, fishes in
            guard let fish = fishes.first else {
                return nil
            }

            return BannerFishItem(
                id: fishID,
                fish: fish,
                count: fishes.count
            )
        }
        .sorted { $0.fish.name < $1.fish.name }
    }
}
