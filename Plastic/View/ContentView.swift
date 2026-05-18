import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var toastViewModel: ToastViewModel
    @EnvironmentObject private var bannerViewModel: BannerViewModel

    var body: some View {
        ZStack {
            HomeView()

            // 魚を獲得したときの帯状バナーを表示
            if bannerViewModel.showingBanner {
                BannerView()
                    .transition(.opacity)
                    .animation(.easeInOut, value: bannerViewModel.showingBanner)
            }

            // 画面上部にトーストを表示
            if toastViewModel.showToast {
                VStack {
                    ToastView()
                        .padding(.top, 50)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: toastViewModel.showToast)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ToastViewModel())
        .environmentObject(BannerViewModel())
}
