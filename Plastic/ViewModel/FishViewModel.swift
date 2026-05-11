import Combine
import Foundation

final class FishViewModel: ObservableObject {
    let fishModels: [FishModel]

    @Published var fishCountText: String
    @Published var fishItems: [FishItemViewModel] // 魚個別ViewModelリスト

    init(fishModels: [FishModel]) {
        self.fishModels = fishModels
        self.fishCountText = ""
        self.fishItems = []
        refreshDisplayProperties()
    }

    // 検索
    func fishModel(for fishID: String) -> FishModel? {
        fishModels.first { $0.fishID == fishID }
    }

    // 所持数増加メソッド
    func increaseOwnedCount(for fishID: String) {
        var fish = self.fishModel(for: fishID)
        fish?.increaseOwnedCount()
        refreshDisplayProperties()
    }

    func refreshDisplayProperties() {
        fishCountText = "\(fishModels.count)"
        fishItems = fishModels.map { FishItemViewModel(fishModel: $0) }
    }
}
