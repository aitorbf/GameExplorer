//
//  GameExplorerApp.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import SwiftUI

@main
struct GameExplorerApp: App {

    var body: some Scene {
        WindowGroup {
            RootView(coordinator: AppCoordinator(container: DIContainer()))
                .preferredColorScheme(.dark)
        }
    }
}
