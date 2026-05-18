import CoreGraphics
import SwiftUI

// 魚データ構造体
struct FishStruct: Identifiable {
    let id: String
    let name: String // 名前
    let image: Image // 立ち絵画像
    let image2: Image // ボックス用画像
    let size: Int // サイズ
    let portraitSize: CGSize // 立ち絵サイズ
    let classification: String // 分類
    let label: String // 計測ラベル


    init(
        id: String,
        name: String,
        image: Image,
        image2: Image,
        size: Int,
        portraitSize: CGSize,
        classification: String,
        label: String
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.image2 = image2
        self.size = size
        self.portraitSize = portraitSize
        self.classification = classification
        self.label = label
    }
}

// 魚データリスト構造体////////////中身を変える予定
struct allFish {
    static let fishes: [FishStruct] = [
        FishStruct(
            id: "salmon",
            name: "Salmon",
            image: Image("salmon"),
            image2: Image("salmon"),
            size: 5000,
            portraitSize: CGSize(width: 120, height: 80),
            classification: "River",
            label: "Plastic"
        ),
        FishStruct(
            id: "buri",
            name: "Buri",
            image: Image("buri"),
            image2: Image("buri"),
            size: 10000,
            portraitSize: CGSize(width: 160, height: 90),
            classification: "Sea",
            label: "Plastic"
        ),
        FishStruct(
            id: "katuo",
            name: "Katuo",
            image: Image("katuo"),
            image2: Image("katuo"),
            size: 3000,
            portraitSize: CGSize(width: 160, height: 90),
            classification: "Sea",
            label: "Plastic"
        ),
        FishStruct(
            id: "saba",
            name: "Saba",
            image: Image("saba"),
            image2: Image("saba"),
            size: 200,
            portraitSize: CGSize(width: 160, height: 90),
            classification: "Sea",
            label: "Bottle"
        ),
        FishStruct(
            id: "aji",
            name: "Aji",
            image: Image("aji"),
            image2: Image("aji"),
            size: 150,
            portraitSize: CGSize(width: 160, height: 90),
            classification: "Sea",
            label: "Bottle"
        )
    ]

    // 検索
    static func fish(for id: String) -> FishStruct? {
        fishes.first { $0.id == id }
    }
}
