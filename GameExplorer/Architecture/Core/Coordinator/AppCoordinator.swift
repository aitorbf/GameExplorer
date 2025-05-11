//
//  AppCoordinator.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 11/5/25.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    
    let discoverCoordinator: Coordinator = Coordinator()
    let favoritesCoordinator: Coordinator = Coordinator()
    
    @MainActor
    func buildHomeScreen() -> some View {
        HomeView(
            discoverViewModel: DIContainer.shared.discoverViewModel(),
            upcomingGamesViewModel: DIContainer.shared.upcomingGamesViewModel(),
            favoritesViewModel: DIContainer.shared.favoritesViewModel()
        )
    }
}
