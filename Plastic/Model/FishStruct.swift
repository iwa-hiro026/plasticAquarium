import CoreGraphics
import SwiftUI

// 魚データ構造体
struct FishStruct: Identifiable {
    let id: String
    let name: String // 名前
    let image: Image // 立ち絵画像
    let size: Int // サイズ
    let portraitSize: CGSize // 立ち絵サイズ
    let classification: String // 分類

    init(
        id: String,
        name: String,
        image: Image,
        size: Int,
        portraitSize: CGSize,
        classification: String
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.size = size
        self.portraitSize = portraitSize
        self.classification = classification
    }
}

// 魚データリスト構造体
struct allFish {
    static let fishes: [FishStruct] = [
        FishStruct(
            id: "salmon",
            name: "Salmon",
            image: Image("salmon"),
            size: 80,
            portraitSize: CGSize(width: 120, height: 80),
            classification: "River"
        ),
        FishStruct(
            id: "tuna",
            name: "Tuna",
            image: Image("tuna"),
            size: 150,
            portraitSize: CGSize(width: 160, height: 90),
            classification: "Sea"
        )
    ]

    // 検索
    static func fish(for id: String) -> FishStruct? {
        fishes.first { $0.id == id }
    }
}
