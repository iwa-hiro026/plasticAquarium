import SwiftUI

struct PlasticMeasureView: View {
    @EnvironmentObject private var playerViewModel: PlayerViewModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 48))
                .foregroundStyle(.accent)

            Text("Plastic Measure")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Plastic")
    }
}

#Preview {
    PlasticMeasureView()
        .environmentObject(PlayerViewModel(playerModel: PlayerModel()))
}
