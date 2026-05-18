import SwiftUI

// 魚を獲得したときに表示する帯状View
struct BannerView: View {
    // 獲得バナーの表示内容を管理するViewModel
    @EnvironmentObject private var bannerViewModel: BannerViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("ゲット")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(bannerViewModel.fishItems) { fishItem in
                        BannerFishCardView(fishItem: fishItem)
                    }
                }
                .padding(.horizontal, 24)
            }

            Button {
                bannerViewModel.closeBanner()
            } label: {
                Text("OK")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 96, height: 24)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .stroke(.white.opacity(0.35), lineWidth: 1)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.black.opacity(0.85)) // 背景のフィルター
    }
}

// 獲得した魚1種類分のカードView
private struct BannerFishCardView: View {
    let fishItem: BannerFishItem

    var body: some View {
        VStack(spacing: 6) {
            fishItem.fish.image2
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)

            Text("x\(fishItem.count)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .frame(width: 74, height: 86)
        .background(.white.opacity(0.16))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.4), lineWidth: 1)
        }
    }
}
