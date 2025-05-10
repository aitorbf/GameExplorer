//
//  HomeView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var discoverViewModel: DiscoverViewModel
    @StateObject var upcomingGamesViewModel: UpcomingGamesViewModel
    @StateObject var favoritesViewModel: FavoritesViewModel
    
    @EnvironmentObject private var appCoordinator: AppCoordinator
    @State private var selectedTab: TabItem = .upcoming
    @State private var isTabBarVisible: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                DiscoverView(viewModel: discoverViewModel)
                    .environmentObject(appCoordinator.discoverCoordinator)
                    .offset(x: selectedTab == .discover ? 0 : -UIScreen.main.bounds.width)
                    .opacity(selectedTab == .discover ? 1 : 0)
                
                UpcomingGamesView(viewModel: upcomingGamesViewModel)
                    .offset(x: selectedTab == .upcoming ? 0 : selectedTab == .favorite ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width)
                    .opacity(selectedTab == .upcoming ? 1 : 0)
                
                FavoritesView(viewModel: favoritesViewModel)
                    .environmentObject(appCoordinator.favoritesCoordinator)
                    .offset(x: selectedTab == .favorite ? 0 : UIScreen.main.bounds.width)
                    .opacity(selectedTab == .favorite ? 1 : 0)
            }

            CustomTabBar(selectedTab: $selectedTab)
                .offset(y: isTabBarVisible ? 0 : 100)
                .opacity(isTabBarVisible ? 1 : 0)
        }
        .background(Color.customBackground.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeInOut, value: isTabBarVisible)
        .environment(\.tabBarVisibility, $isTabBarVisible)
    }
}

#Preview {
    HomeView(
        discoverViewModel: DIContainer.mock.discoverViewModel(),
        upcomingGamesViewModel: DIContainer.mock.upcomingGamesViewModel(),
        favoritesViewModel: DIContainer.mock.favoritesViewModel()
    )
            
}
