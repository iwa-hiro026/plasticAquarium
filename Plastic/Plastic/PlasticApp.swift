//
//  PlasticApp.swift
//  Plastic
//
//  Created by student on 2026/04/27.
//

import SwiftUI
import SwiftData

@main
struct PlasticApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [PlayerModel.self, FishModel.self])
    }
}
