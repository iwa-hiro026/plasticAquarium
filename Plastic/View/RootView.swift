import SwiftUI
import SwiftData

// 保存対象のモデル処理などを行う
struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var playerModels: [PlayerModel]
    @Query private var fishModels: [FishModel]
    @State private var didUpdateLastLoginAt = false
    @StateObject private var toastViewModel = ToastViewModel()
    @StateObject private var bannerViewModel = BannerViewModel()

    var body: some View {
        Group {
            if let playerModel = playerModels.first {
                ContentView()
                    .environmentObject(PlayerViewModel(playerModel: playerModel))
                    .environmentObject(FishViewModel(fishModels: fishModels))
                    .environmentObject(toastViewModel)
                    .environmentObject(bannerViewModel)
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
        for fish in allFish.fishes where !existingFishIDs.contains(fish.id) {
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

