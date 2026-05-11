import Foundation
import SwiftData

// ペットボトル計測可能フラグ構造体
struct BottleMeasurementFlags: Codable {
    var first: Bool
    var second: Bool
    var third: Bool

    init(
        first: Bool = true,
        second: Bool = true,
        third: Bool = true
    ) {
        self.first = first
        self.second = second
        self.third = third
    }

    // フラグが一つでもオンになっているかを返す
    func hasAvailableMeasurement() -> Bool {
        first || second || third
    }

    // フラグを一つ消費する
    mutating func consumeOneMeasurement() -> Bool {
        if first {
            first = false
            return true
        }

        if second {
            second = false
            return true
        }

        if third {
            third = false
            return true
        }

        return false
    }

    static let allTrue = BottleMeasurementFlags()
}

// プレイヤーモデル、保存対象
@Model
final class PlayerModel {
    var totalMeasurementCount: Int
    var plasticMeasurementCount: Int
    var bottleMeasurementCount: Int
    var totalMeasurementAmount: Int
    var plasitcMeasurementAmount: Int
    var bottleMeasurementAmount: Int
    var canMeasurePlasticToday: Bool
    var canMeasureBottleToday: BottleMeasurementFlags
    var lastLoginAt: Date?
    var gameStartedAt: Date

    init(
        totalMeasurementCount: Int = 0,
        plasticMeasurementCount: Int = 0,
        bottleMeasurementCount: Int = 0,
        totalMeasurementAmount: Int = 0,
        plasitcMeasurementAmount: Int = 0,
        bottleMeasurementAmount: Int = 0,
        canMeasurePlasticToday: Bool = true,
        canMeasureBottleToday: BottleMeasurementFlags = .allTrue,
        lastLoginAt: Date? = nil,
        gameStartedAt: Date = Date()
    ) {
        self.totalMeasurementCount = totalMeasurementCount
        self.plasticMeasurementCount = plasticMeasurementCount
        self.bottleMeasurementCount = bottleMeasurementCount
        self.totalMeasurementAmount = totalMeasurementAmount
        self.plasitcMeasurementAmount = plasitcMeasurementAmount
        self.bottleMeasurementAmount = bottleMeasurementAmount
        self.canMeasurePlasticToday = canMeasurePlasticToday
        self.canMeasureBottleToday = canMeasureBottleToday
        self.lastLoginAt = lastLoginAt
        self.gameStartedAt = gameStartedAt
    }

    // 最終ログイン日時を現在日時に更新
    func updateLastLoginAtToToday() {
        // 日付更新前にフラグ判定を行う
        self.resetBottleMeasurementIfNeeded()
        self.resetPlasticMeasurementIfNeeded()
        lastLoginAt = Date()
    }

    // 最終ログイン日が今日でなければペットボトル計測フラグをオンにする
    func resetBottleMeasurementIfNeeded() {
        guard let lastLoginAt else {
            canMeasureBottleToday = .allTrue
            return
        }

        if !Calendar.current.isDateInToday(lastLoginAt) {
            canMeasureBottleToday = .allTrue
        }
    }

    // 最終ログイン日が今日でなく、かつ火曜日ならプラごみ計測フラグをオンにする
    func resetPlasticMeasurementIfNeeded() {
        let isTuesday = Calendar.current.component(.weekday, from: Date()) == 3
        let isNotToday = lastLoginAt.map { !Calendar.current.isDateInToday($0) } ?? true

        if isNotToday && isTuesday {
            canMeasurePlasticToday = true
        }
    }

    // ペットボトル計測
    func measureBottle(amount: Int) -> Bool {
        if !self.canMeasureBottleToday.consumeOneMeasurement() {
            return false
        }
        self.bottleMeasurementCount += 1
        self.bottleMeasurementAmount += amount
        self.measureTotal(amount: amount)
        return true
    }

    // プラごみ計測
    func measurePlastic(amount: Int) -> Bool {
        if !self.canMeasurePlasticToday {
            return false
        }
        self.canMeasurePlasticToday = false
        self.plasticMeasurementCount += 1
        self.plasitcMeasurementAmount += amount
        self.measureTotal(amount: amount)
        return true
    }

    func measureTotal(amount: Int) {
        self.totalMeasurementCount += 1
        self.totalMeasurementAmount += amount
    }
}
