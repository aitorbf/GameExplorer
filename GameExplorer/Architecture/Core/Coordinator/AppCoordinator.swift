//
//  AppCoordinator.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 26/4/25.
//


import SwiftUI

final class AppCoordinator: ObservableObject {
    
    @Published var rootTab: TabItem = .upcoming

    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func makeSearchView() -> some View {
        NavigationStack {
            SearchView()
                .navigationTitle("Search")
                .background(Color(.background).ignoresSafeArea())
                .toolbarSetup()
        }
    }

    @MainActor
    func makeUpcomingView() -> some View {
        NavigationStack {
            UpcomingGamesView(viewModel: container.upcomingGamesViewModel())
                .navigationTitle("Upcoming Games")
                .background(Color(.background).ignoresSafeArea())
                .toolbarSetup()
        }
    }

    func makeFavoriteView() -> some View {
        NavigationStack {
            FavoriteView()
                .navigationTitle("Favorites")
                .background(Color(.background).ignoresSafeArea())
                .toolbarSetup()
        }
    }
}
