import SwiftUI

enum Description {
    case Bottle
    case Plastic
}

// タブビューのページ形式で選択
struct MeasurePageView: View {
    @State private var selectedPage = 0
    @ObservedObject private var measureViewModel : MeasureViewModel
    
    var body: some View {
        TabView(selection: $selectedPage) {
            MeasurePageItemView(
                title: "Bottle_500ml",
                description: Description.Bottle,
                systemImage: "1.circle.fill",
                amount: 500,
                measureViewModel : measureViewModel
            )
            .tag(0)

            MeasurePageItemView(
                title: "Plastic_45L",
                description: Description.Plastic,
                systemImage: "2.circle.fill",
                amount: 45000,
                measureViewModel : measureViewModel
            )
            .tag(1)

        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
    }
}

// ページ
private struct MeasurePageItemView: View {
    @EnvironmentObject private var playerViewModel: PlayerViewModel
    @EnvironmentObject private var toastViewModel: ToastViewModel
    @ObservedObject private var measureViewModel : MeasureViewModel

    let title: String
    let description: Description
    let systemImage: String
    let amount: Int

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 56))
                .foregroundStyle(.accent)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(String(description))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            // ボタン、計測不可能ならトースト通知
            if description == Description.Bottle{
                // ペットボトル
                Button {
                    if playerViewModel.hasAvailableBottleMeasurement() {
                        measureViewModel.openCamera(label: "Bottle")
                    }
                    else
                    {
                        toastViewModel.toastPreview(message: "計測可能回数が残っていません")
                    }
                } label: {
                    Text("計測")
                }
                .buttonStyle(.plain)
            }
            else
            {
                // プラごみ
                Button {
                    if playerViewModel.canMeasurePlasticTodayValue {
                        measureViewModel.openCamera(label: "Plastic")
                    }
                    else
                    {
                        toastViewModel.toastPreview(message: "計測可能回数が残っていません")
                    }
                } label: {
                    Text("計測")
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }
}

#Preview {
    MeasurePageView()
}
