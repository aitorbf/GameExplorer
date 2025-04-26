//
//  RootView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $coordinator.rootTab) {
                coordinator.makeSearchView()
                    .tag(TabItem.search)
                
                coordinator.makeUpcomingView()
                    .tag(TabItem.upcoming)
                
                coordinator.makeFavoriteView()
                    .tag(TabItem.favorite)
            }
            .tint(Color(.textPrimary))
            .toolbarBackground(Color(.surface), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
            customTabBar
        }
        .background(Color(.background).ignoresSafeArea())
    }
    
    private var customTabBar: some View {
        ZStack {
            HStack {
                ForEach(TabItem.allCases, id: \.self) { item in
                    Button {
                        coordinator.rootTab = item
                    } label: {
                        customTabItem(
                            imageName: item.iconName,
                            title: item.title,
                            isActive: (coordinator.rootTab == item)
                        )
                    }
                }
            }
            .padding(6)
        }
        .frame(height: 70)
        .background(Color(.highlightPurple))
        .cornerRadius(35)
        .padding(.horizontal, 26)
    }
    
    private func customTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? Color(.textPrimary) : Color(.shadowPurple))
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isActive ? Color(.textPrimary) : Color(.shadowPurple))
            }
            Spacer()
        }
        .frame(maxWidth: isActive ? .infinity : 60, maxHeight: 60)
        .background(isActive ? Color(.shadowPurple) : .clear)
        .cornerRadius(30)
    }
}

enum TabItem: Int, CaseIterable{
    
    case search = 0
    case upcoming = 1
    case favorite = 2
    
    var title: String{
        switch self {
        case .search:
            return "Search"
        case .upcoming:
            return "Upcoming"
        case .favorite:
            return "Favorites"
        }
    }
    
    var iconName: String{
        switch self {
        case .search:
            return "magnifyingglass"
        case .upcoming:
            return "calendar"
        case .favorite:
            return "star.fill"
        }
    }
}

#Preview {
    let container = DIContainer.mock
    let coordinator = AppCoordinator(container: container)
    RootView(coordinator: coordinator)
}
