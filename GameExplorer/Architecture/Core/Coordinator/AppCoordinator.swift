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
        ZStack {
            HomeView(
                discoverViewModel: DIContainer.shared.getDiscoverViewModel(),
                upcomingGamesViewModel: DIContainer.shared.getUpcomingGamesViewModel(),
                favoritesViewModel: DIContainer.shared.getFavoritesViewModel()
            )
            
            SplashScreen()
        }
    }
}
