import SpriteKit
import UIKit

// 魚の見た目と泳ぐ動きをまとめたSpriteKitノード
final class FishNode: SKNode {
    private let fishID: String
    private let fallbackImageName: String
    private let swimsToRight: Bool
    private let fishScale: CGFloat

    init(
        fishID: String,
        fallbackImageName: String = "fish_default",
        swimsToRight: Bool = Bool.random(),
        fishScale: CGFloat = 1.0
    ) {
        self.fishID = fishID
        self.fallbackImageName = fallbackImageName
        self.swimsToRight = swimsToRight
        self.fishScale = fishScale
        super.init()
        setupShape()
        startWiggleAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 画面外から出現し、反対側の画面外まで移動する
    func swimAcross(sceneSize: CGSize) {
        // 出現高さ抽選
        let yPosition = CGFloat.random(in: sceneSize.height * 0.2...sceneSize.height * 0.8)
        let outsideMargin = 80 * fishScale

        // 左右の出現位置を計算
        let startX = swimsToRight ? -outsideMargin : sceneSize.width + outsideMargin
        let endX = swimsToRight ? sceneSize.width + outsideMargin : -outsideMargin

        position = CGPoint(x: startX, y: yPosition)
        xScale = swimsToRight ? fishScale : -fishScale
        yScale = fishScale

        // 移動、5~8秒間かけて終点まで移動
        let move = SKAction.moveTo(x: endX, duration: Double.random(in: 5.0...8.0))
        // 削除
        let remove = SKAction.removeFromParent()
        // 2つの処理を実行、移動処理が終了すると削除処理を実行する。
        run(SKAction.sequence([move, remove]))
    }

    // fishIDと同じ名前の画像を表示する。画像がなければ代わりの画像を表示する
    private func setupShape() {
        let fishImage = SKSpriteNode(imageNamed: imageName())
        fishImage.size = CGSize(width: 80, height: 50)
        addChild(fishImage)
    }

    // AssetsにfishIDの画像があるか確認する、なければフォールバック用の画像名を返す
    private func imageName() -> String {
        UIImage(named: fishID) == nil ? fallbackImageName : fishID
    }

    // 泳いでいるように上下へゆらす
    private func startWiggleAnimation() {
        let swimUp = SKAction.moveBy(x: 0, y: 8, duration: 0.5)
        let swimDown = SKAction.moveBy(x: 0, y: -8, duration: 0.5)
        swimUp.timingMode = .easeInEaseOut
        swimDown.timingMode = .easeInEaseOut
        run(SKAction.repeatForever(SKAction.sequence([swimUp, swimDown])))
    }
}
