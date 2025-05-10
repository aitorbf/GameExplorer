//
//  GameExplorerApp.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import SwiftUI

@main
struct GameExplorerApp: App {
    
    @StateObject var appCoordinator = AppCoordinator()
    
    init() {
        DIContainer.initialize(context: SwiftDataManager.shared.modelContext)
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator
                .buildHomeScreen()
                .preferredColorScheme(.dark)
                .tint(.white)
                .environmentObject(appCoordinator)
        }
    }
}
