import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            // 水槽
            NavigationStack {
                ExibitionView()
                .tabItem {
                    // タブの見た目
                    Image(systemName: "fish")
                    Text("水槽")
                }
            }

            // データ
            NavigationStack {
                DataView()
                .tabItem {
                    // タブの見た目
                    Image(systemName: "chart.bar.fill")
                    Text("データ")
                }
            }

            // ボックス
            NavigationStack {
                BoxView()
                .tabItem {
                    // タブの見た目
                    Image(systemName: "shippingbox.fill")
                    Text("ボックス")
                }
            }
            
            // 計測
            NavigationStack {
                MeasureView()
                .tabItem {
                    // タブの見た目
                    Image(systemName: "ruler")
                    Text("計測")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
