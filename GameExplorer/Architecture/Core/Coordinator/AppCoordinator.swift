//
//  AppCoordinator.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 26/4/25.
//


import SwiftUI

final class AppCoordinator: ObservableObject {
    
    @Published var rootTab: TabItem = .upcoming
    
    private let container: DIContainer
    
    private lazy var searchView: AnyView = {
        AnyView(
            NavigationStack {
                DiscoverView(viewModel: container.discoverViewModel())
                    .navigationTitle("Discover")
                    .background(Color(.background).ignoresSafeArea())
                    .toolbarSetup()
            }
        )
    }()
    
    private lazy var upcomingView: AnyView = {
        AnyView(
            NavigationStack {
                UpcomingGamesView(viewModel: container.upcomingGamesViewModel())
                    .navigationTitle("Upcoming Games")
                    .background(Color(.background).ignoresSafeArea())
                    .toolbarSetup()
            }
        )
    }()
    
    private lazy var favoriteView: AnyView = {
        AnyView(
            NavigationStack {
                FavoriteView()
                    .navigationTitle("Favorites")
                    .background(Color(.background).ignoresSafeArea())
                    .toolbarSetup()
            }
        )
    }()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeSearchView() -> some View {
        searchView
    }
    
    func makeUpcomingView() -> some View {
        upcomingView
    }
    
    func makeFavoriteView() -> some View {
        favoriteView
    }
}
