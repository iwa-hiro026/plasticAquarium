import CoreGraphics
import SwiftUI

// 魚データ構造体
struct FishStruct: Identifiable {
    let id: String
    let name: String // 名前
    let image: Image // 立ち絵画像
    let image2: Image // ボックス用画像
    let size: Int // サイズ
    let portraitSize: Int // 立ち絵サイズ
    let classification: String // 分類
    let label: String // 計測ラベル


    init(
        id: String,
        name: String,
        image: Image,
        image2: Image,
        size: Int,
        portraitSize: Int,
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
            image: Image("fish_default"),
            image2: Image("fish_default2"),
            size: 5000,
            portraitSize: 700,
            classification: "River",
            label: "Plastic"
        ),
        FishStruct(
            id: "buri",
            name: "Buri",
            image: Image("fish_default"),
            image2: Image("fish_default2"),
            size: 10000,
            portraitSize: 600,
            classification: "Sea",
            label: "Plastic"
        ),
        FishStruct(
            id: "katuo",
            name: "Katuo",
            image: Image("katuo"),
            image2: Image("katuo2"),
            size: 3000,
            portraitSize: 400,
            classification: "Sea",
            label: "Plastic"
        ),
        FishStruct(
            id: "saba",
            name: "Saba",
            image: Image("fish_default"),
            image2: Image("fish_default2"),
            size: 200,
            portraitSize: 200,
            classification: "Sea",
            label: "Bottle"
        ),
        FishStruct(
            id: "aji",
            name: "Aji",
            image: Image("fish_default"),
            image2: Image("fish_default2"),
            size: 150,
            portraitSize: 150,
            classification: "Sea",
            label: "Bottle"
        )
    ]

    // 検索
    static func fish(for id: String) -> FishStruct? {
        fishes.first { $0.id == id }
    }
}
