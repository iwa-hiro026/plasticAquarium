import Foundation
import SwiftData

// 魚状態モデル
@Model
final class FishModel {
    @Attribute(.unique) var fishID: String
    var ownedCount: Int // 所持数
    var firstObtainedAt: Date? // 初入手日

    init(
        fishID: String,
        ownedCount: Int = 0,
        firstObtainedAt: Date? = nil
    ) {
        self.fishID = fishID
        self.ownedCount = ownedCount
        self.firstObtainedAt = firstObtainedAt
    }

    // 所持数増加メソッド
    func increaseOwnedCount() {
        // 未所持だったら初ゲット日を記録
        if ownedCount == 0 {
            firstObtainedAt = Calendar.current.startOfDay(for: Date())
        }

        ownedCount += 1
    }
}
