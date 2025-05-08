//
//  RootView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var discoverViewModel = DIContainer.shared.discoverViewModel()
    @StateObject var upcomingGamesViewModel = DIContainer.shared.upcomingGamesViewModel()
    @StateObject var favoritesViewModel = DIContainer.shared.favoritesViewModel()
    
    @StateObject private var coordinator: Coordinator = Coordinator()
    @State private var selectedTab: TabItem = .upcoming
    @State private var isTabBarVisible: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                DiscoverView(viewModel: discoverViewModel)
                    .environmentObject(coordinator)
                    .offset(x: selectedTab == .discover ? 0 : -UIScreen.main.bounds.width)
                    .opacity(selectedTab == .discover ? 1 : 0)

                UpcomingGamesView(viewModel: upcomingGamesViewModel)
                    .offset(x: selectedTab == .upcoming ? 0 : selectedTab == .favorite ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width)
                    .opacity(selectedTab == .upcoming ? 1 : 0)

                FavoritesView(viewModel: favoritesViewModel)
                    .environmentObject(coordinator)
                    .offset(x: selectedTab == .favorite ? 0 : UIScreen.main.bounds.width)
                    .opacity(selectedTab == .favorite ? 1 : 0)
            }

            CustomTabBar(selectedTab: $selectedTab)
                .offset(y: isTabBarVisible ? 0 : 100)
                .opacity(isTabBarVisible ? 1 : 0)
        }
        .tint(Color(.textPrimary))
        .background(Color(.background).ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeInOut, value: isTabBarVisible)
        .environment(\.tabBarVisibility, $isTabBarVisible)
    }
}

#Preview {
    RootView(
        discoverViewModel: DIContainer.mock.discoverViewModel(),
        upcomingGamesViewModel: DIContainer.mock.upcomingGamesViewModel(),
        favoritesViewModel: DIContainer.mock.favoritesViewModel()
    )
            
}
