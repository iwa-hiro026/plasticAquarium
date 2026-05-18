import Combine
import SwiftUI
import Foundation

// プレイヤー表示用ViewModel。画面に表示する値をまとめて持つ
final class PlayerViewModel: ObservableObject {
    let playerModel: PlayerModel
    private var toastViewModel: ToastViewModel?

    @Published var totalMeasurementCountText: String
    @Published var plasticMeasurementCountText: String
    @Published var bottleMeasurementCountText: String
    @Published var totalMeasurementAmountText: String
    @Published var plasticMeasurementAmountText: String
    @Published var bottleMeasurementAmountText: String
    @Published var canMeasurePlasticTodayValue: Bool
    @Published var canMeasureBottleToday1Value: Bool
    @Published var canMeasureBottleToday2Value: Bool
    @Published var canMeasureBottleToday3Value: Bool
    @Published var lastLoginAtText: String
    @Published var gameStartedAtText: String

    // 日付表示フォーマッタ
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()

    init(playerModel: PlayerModel) {
        self.playerModel = playerModel
        self.totalMeasurementCountText = ""
        self.plasticMeasurementCountText = ""
        self.bottleMeasurementCountText = ""
        self.totalMeasurementAmountText = ""
        self.plasticMeasurementAmountText = ""
        self.bottleMeasurementAmountText = ""
        self.canMeasurePlasticTodayValue = false
        self.canMeasureBottleToday1Value = false
        self.canMeasureBottleToday2Value = false
        self.canMeasureBottleToday3Value = false
        self.lastLoginAtText = ""
        self.gameStartedAtText = ""
        refreshDisplayProperties()
    }
    
    func setToastViewModel(_ toastViewModel: ToastViewModel) {
        self.toastViewModel = toastViewModel
    }

    // プレイヤーモデルから表示値を更新する
    func refreshDisplayProperties() {
        totalMeasurementCountText = "\(playerModel.totalMeasurementCount)"
        plasticMeasurementCountText = "\(playerModel.plasticMeasurementCount)"
        bottleMeasurementCountText = "\(playerModel.bottleMeasurementCount)"
        totalMeasurementAmountText = "\(playerModel.totalMeasurementAmount)"
        plasticMeasurementAmountText = "\(playerModel.plasitcMeasurementAmount)"
        bottleMeasurementAmountText = "\(playerModel.bottleMeasurementAmount)"
        canMeasurePlasticTodayValue = playerModel.canMeasurePlasticToday
        canMeasureBottleToday1Value = playerModel.canMeasureBottleToday.first
        canMeasureBottleToday2Value = playerModel.canMeasureBottleToday.second
        canMeasureBottleToday3Value = playerModel.canMeasureBottleToday.third
        lastLoginAtText = formattedDate(playerModel.lastLoginAt)
        gameStartedAtText = formattedDate(playerModel.gameStartedAt)
    }

    // ペットボトル計測が可能かを返す
    func hasAvailableBottleMeasurement() -> Bool {
        playerModel.canMeasureBottleToday.hasAvailableMeasurement()
    }

    // ペットボトル計測
    func measureBottle(amount: Int) {
        if self.playerModel.measureBottle(amount: amount) {
            refreshDisplayProperties()
            toastViewModel?.toastPreview(message: "計測しました")
        } else {
            toastViewModel?.toastPreview(message: "計測に失敗しました")
        }
    }

    // プラごみ計測
    func measurePlastic(amount: Int) {
        if self.playerModel.measurePlastic(amount: amount) {
            refreshDisplayProperties()
            toastViewModel?.toastPreview(message: "計測しました")
        } else {
            toastViewModel?.toastPreview(message: "計測に失敗しました")
        }
    }

    // 日付表示フォーマッタ用の変換
    private func formattedDate(_ date: Date?) -> String {
        guard let date else {
            return "nil"
        }

        return dateFormatter.string(from: date)
    }
}
