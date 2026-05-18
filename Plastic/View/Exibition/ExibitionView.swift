import SwiftUI
import SpriteKit

// SpriteKitのシーンをSwiftUI上に表示するView
struct ExibitionView: View {
    @EnvironmentObject private var fishViewModel: FishViewModel

    private let backgroundImageName: String?

    init(backgroundImageName: String? = nil) {
        self.backgroundImageName = backgroundImageName
    }

    var body: some View {
        GeometryReader { geometry in
            SpriteView(scene: makeScene(size: geometry.size))
                .ignoresSafeArea()
        }
    }

    // SwiftUIの表示サイズに合わせてGameSceneを作成
    private func makeScene(size: CGSize) -> GameScene {
        let scene = GameScene(size: size)
        scene.backgroundImageName = backgroundImageName
        scene.fishModels = fishViewModel.fishModels
        scene.scaleMode = .resizeFill
        return scene
    }
}

// 水槽画面のSpriteKitシーン
final class GameScene: SKScene {
    var backgroundImageName: String?
    var fishModels: [FishModel] = []

    private var backgroundNode: SKSpriteNode?
    private var fishSpawnQueue: [String] = [] // 出現させる魚のfishIDを格納、格納順に出現

    // 初期設定実行
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.systemCyan
        setupBackground()
        startFishAnimation()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateBackgroundLayout()
    }

    // 指定された画像を水槽の背景として配置する
    private func setupBackground() {
        guard let backgroundImageName else { return }

        let backgroundNode = SKSpriteNode(imageNamed: backgroundImageName)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)

        self.backgroundNode = backgroundNode
        updateBackgroundLayout()
    }

    // シーンサイズに合わせて背景画像を画面いっぱいに広げる
    private func updateBackgroundLayout() {
        backgroundNode?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode?.size = size
    }

    // 一定間隔で魚を出現させ続ける
    private func startFishAnimation() {
        let wait = SKAction.wait(forDuration: 1.2, withRange: 0.8)
        let spawn = SKAction.run { [weak self] in
            self?.swimFishAcrossScreen()
        }
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])))
    }

    // 魚を1匹作り、画面の端から端へ泳がせる
    private func swimFishAcrossScreen() {
        guard let fishID = nextFishID() else { return }

        let fish = FishNode(
            fishID: fishID,
            swimsToRight: Bool.random(),
            fishScale: fishScale(for: fishID)
        )
        addChild(fish)
        fish.swimAcross(sceneSize: size)
    }

    // 次に出現させる魚を取得するメソッド
    private func nextFishID() -> String? {
        // 出現配列が空ならシャッフルしなおす
        if fishSpawnQueue.isEmpty {
            fishSpawnQueue = shuffledOwnedFishIDs()
        }

        guard !fishSpawnQueue.isEmpty else { return nil }
        
        // 出現させた魚は配列から除外
        return fishSpawnQueue.removeFirst()
    }

    // 所持している魚をシャッフルする
    private func shuffledOwnedFishIDs() -> [String] {
        fishModels
            .filter { $0.ownedCount > 0 } // 所持している魚のみに絞り込み
            .flatMap { fishModel in
                Array(repeating: fishModel.fishID, count: fishModel.ownedCount)
            } // 所持数分だけ配列に追加
            .shuffled() // シャッフル
    }

    // 魚データのサイズをSpriteKit用の倍率に変換する
    private func fishScale(for fishID: String) -> CGFloat {
        guard let fishData = allFish.fish(for: fishID) else {
            return 1.0
        }

        return CGFloat(fishData.size) / 100
    }
}
