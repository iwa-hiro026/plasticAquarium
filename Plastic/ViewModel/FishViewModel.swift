import Combine
import Foundation

final class FishViewModel: ObservableObject {
    let fishModels: [FishModel]
    private var bannerViewModel: BannerViewModel?

    @Published var fishCountText: String
    @Published var fishItems: [FishItemViewModel]

    init(fishModels: [FishModel]) {
        self.fishModels = fishModels
        self.fishCountText = ""
        self.fishItems = []
        refreshDisplayProperties()
    }

    // Get BannerViewModel.
    func setBannerViewModel(_ bannerViewModel: BannerViewModel) {
        self.bannerViewModel = bannerViewModel
    }

    // Search fish model.
    func fishModel(for fishID: String) -> FishModel? {
        fishModels.first { $0.fishID == fishID }
    }

    // Increase owned count.
    func increaseOwnedCount(for fishID: String) {
        var fish = self.fishModel(for: fishID)
        fish?.increaseOwnedCount()
        refreshDisplayProperties()
    }

    func refreshDisplayProperties() {
        fishCountText = "\(fishModels.count)"
        fishItems = fishModels.map { FishItemViewModel(fishModel: $0) }
    }

    // Get random fishes.
    func getFishRandom(amount: Int, label: String) {
        let minTotalSize = Int(Double(amount) * 0.9)
        let maxTotalSize = Int(Double(amount) * 1.1)

        // Repeat selection until total size is within +/-10%.
        for _ in 0..<100 {
            var selectedFishes: [FishStruct] = []
            var totalSize = 0

            while totalSize < minTotalSize {
                let fishCandidates = filteredFishCandidates(
                    label: label,
                    currentTotalSize: totalSize,
                    maxTotalSize: maxTotalSize
                )

                guard let selectedFish = fishCandidates.randomElement() else {
                    break
                }

                selectedFishes.append(selectedFish)
                totalSize += selectedFish.size
            }

            guard totalSize >= minTotalSize && totalSize <= maxTotalSize else {
                continue
            }

            selectedFishes.forEach { fish in
                increaseOwnedCount(for: fish.id)
            }

            bannerViewModel?.showBanner(fishes: selectedFishes)
            return
        }
    }

    // Filter fishes by label and max size.
    private func filteredFishCandidates(label: String, currentTotalSize: Int, maxTotalSize: Int) -> [FishStruct] {
        allFish.fishes.filter { fish in
            fish.label == label && currentTotalSize + fish.size <= maxTotalSize
        }
    }
}
