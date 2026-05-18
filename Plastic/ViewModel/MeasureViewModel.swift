import SwiftUI
import Combine

final class MeasureViewModel : ObservableObject {
    @Published var showingCamera = false // カメラ起動フラグ
    @Published var isRecognized = false // カメラ認証フラグ
    @Published var label = "" // ラベル

    @Published var amount = 0
    private var fishViewModel: FishViewModel?
    private var playerViewModel: PlayerViewModel?

    // FishViewModel取得
    func setFishViewModel(_ fishViewModel: FishViewModel) {
        self.fishViewModel = fishViewModel
    }

    // PlayerViewModel取得
    func setPlayerViewModel(_ playerViewModel: PlayerViewModel) {
        self.playerViewModel = playerViewModel
    }
    
    // カメラ起動
    func openCamera(label: String, amount: Int) {
        self.label = label
        self.isRecognized = false
        self.showingCamera = true
        self.amount = amount

        // test
        self.isRecognized = true
        // test
    }

    // カメラ停止
    func closeCamera() {
        self.showingCamera = false
        // 認証成功しているか
        if self.isRecognized {
            // プレイヤーデータ記録処理
            measurePlayer()
            // 魚獲得処理
            fishViewModel?.getFishRandom(amount: amount, label: label)
        }
        self.isRecognized = false
        self.label = ""
        self.amount = 0
    }

    private func measurePlayer() {
        switch label {
        case "Bottle":
            playerViewModel?.measureBottle(amount: amount)
        case "Plastic":
            playerViewModel?.measurePlastic(amount: amount)
        default:
            break
        }
    }
}
