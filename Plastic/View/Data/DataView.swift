import SwiftUI

struct DataView: View {
    @EnvironmentObject private var playerViewModel: PlayerViewModel

    var body: some View {
        List {
            Section("Player Data") {
                DataRowView(
                    title: "累計計測回数",
                    value: playerViewModel.totalMeasurementCountText
                )
                DataRowView(
                    title: "繝励Λ縺斐∩險域ｸｬ蝗樊焚",
                    value: playerViewModel.plasticMeasurementCountText
                )
                DataRowView(
                    title: "Bottle Measurement Count",
                    value: playerViewModel.bottleMeasurementCountText
                )
                DataRowView(
                    title: "Total Measurement Amount",
                    value: playerViewModel.totalMeasurementAmountText
                )
                DataRowView(
                    title: "Plastic Measurement Amount",
                    value: playerViewModel.plasticMeasurementAmountText
                )
                DataRowView(
                    title: "Bottle Measurement Amount",
                    value: playerViewModel.bottleMeasurementAmountText
                )
                DataRowView(
                    title: "Last Login At",
                    value: playerViewModel.lastLoginAtText
                )
                DataRowView(
                    title: "Game Started At",
                    value: playerViewModel.gameStartedAtText
                )
            }
        }
        .navigationTitle("Data")
        .onAppear {
            // 表示するときにViewModelの値を更新
            playerViewModel.refreshDisplayProperties()
        }
    }
}
