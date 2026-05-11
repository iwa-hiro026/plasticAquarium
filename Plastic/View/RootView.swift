import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var playerModels: [PlayerModel]
    @Query private var fishModels: [FishModel]
    @State private var didUpdateLastLoginAt = false
    @StateObject private var toastViewModel = ToastViewModel()

    var body: some View {
        Group {
            if let playerModel = playerModels.first {
                ContentView()
                    .environmentObject(PlayerViewModel(playerModel: playerModel))
                    .environmentObject(FishViewModel(fishModels: fishModels))
                    .environmentObject(toastViewModel)
            } else {
                ProgressView()
            }
        }
        .task {
            bootstrapModelsIfNeeded()
            updateLastLoginAtIfNeeded()
        }
    }

    private func bootstrapModelsIfNeeded() {
        if playerModels.isEmpty {
            modelContext.insert(PlayerModel())
        }

        let existingFishIDs = Set(fishModels.map(\.fishID))
        for fish in FishType.fishes where !existingFishIDs.contains(fish.id) {
            modelContext.insert(FishModel(fishID: fish.id))
        }
    }

    private func updateLastLoginAtIfNeeded() {
        guard !didUpdateLastLoginAt, let playerModel = playerModels.first else {
            return
        }

        playerModel.updateLastLoginAtToToday()
        didUpdateLastLoginAt = true
    }
}

#Preview {
    RootView()
        .modelContainer(for: [PlayerModel.self, FishModel.self], inMemory: true)
}
