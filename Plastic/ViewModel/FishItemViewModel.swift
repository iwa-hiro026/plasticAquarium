import Combine
import Foundation

// 魚個別用ViewModel
final class FishItemViewModel: ObservableObject, Identifiable {
    let fishModel: FishModel
    let id: String

    @Published var nameText: String
    @Published var classificationText: String
    @Published var ownedCountText: String
    @Published var firstObtainedAtText: String

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()

    init(fishModel: FishModel) {
        self.fishModel = fishModel
        self.id = fishModel.fishID
        self.nameText = ""
        self.classificationText = ""
        self.ownedCountText = ""
        self.firstObtainedAtText = ""
        refreshDisplayProperties()
    }

    func refreshDisplayProperties() {
        let fishData = allFish.fish(for: fishModel.fishID)
        nameText = fishData?.name ?? fishModel.fishID
        classificationText = fishData?.classification ?? "-"
        ownedCountText = "\(fishModel.ownedCount)"
        firstObtainedAtText = formattedDate(fishModel.firstObtainedAt)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else {
            return "nil"
        }

        return dateFormatter.string(from: date)
    }
}
