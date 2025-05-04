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
    
    @StateObject private var coordinator: Coordinator = Coordinator()
    @State private var selectedTab: TabItem = .discover
    @State private var isTabBarVisible: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                DiscoverView(viewModel: discoverViewModel)
                    .environmentObject(coordinator)
                    .tag(TabItem.discover)
                
                UpcomingGamesView(viewModel: upcomingGamesViewModel)
                    .tag(TabItem.upcoming)
                
                FavoritesView()
                    .tag(TabItem.favorite)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
                .offset(y: isTabBarVisible ? 0 : 100)
                .opacity(isTabBarVisible ? 1 : 0)
                .animation(.smooth, value: isTabBarVisible)
        }
        .tint(Color(.textPrimary))
        .background(Color(.background).ignoresSafeArea())
        .environment(\.tabBarVisibility, $isTabBarVisible)
    }
}

#Preview {
    RootView(
        discoverViewModel: DIContainer.mock.discoverViewModel(),
        upcomingGamesViewModel: DIContainer.mock.upcomingGamesViewModel()
    )
            
}
