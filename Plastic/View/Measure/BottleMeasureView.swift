import SwiftUI

struct BottleMeasureView: View {
    @EnvironmentObject private var playerViewModel: PlayerViewModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "waterbottle.fill")
                .font(.system(size: 48))

            Text("Bottle Measure")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Bottle")
    }
}

#Preview {
    BottleMeasureView()
        .environmentObject(PlayerViewModel(playerModel: PlayerModel()))
}
