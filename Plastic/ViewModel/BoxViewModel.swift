import Combine
import Foundation

final class BoxViewModel: ObservableObject {
    @Published var selectedFishItem: FishItemViewModel?

    func showFishDetail(fishItem: FishItemViewModel) {
        selectedFishItem = fishItem
    }

    func dismissFishDetail() {
        selectedFishItem = nil
    }
}
