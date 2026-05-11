import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var toastViewModel: ToastViewModel

    var body: some View {
        ZStack {
            HomeView()

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
}
