import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            // データ
            NavigationStack {
                DataView()
                .tabItem {
                    // タブの見た目
                    Image(systemName: "house")
                    Text("データ")
                }
            }
            
            // 計測
            NavigationStack {
                MeasureView()
                .tabItem {
                    // タブの見た目
                    Image(systemName: "house")
                    Text("計測")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
