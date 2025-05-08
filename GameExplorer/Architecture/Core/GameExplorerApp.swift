//
//  GameExplorerApp.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import SwiftUI

@main
struct GameExplorerApp: App {
    
    init() {
        DIContainer.initialize(context: SwiftDataManager.shared.modelContext)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
