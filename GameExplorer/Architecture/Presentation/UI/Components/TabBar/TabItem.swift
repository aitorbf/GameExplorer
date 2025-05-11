//
//  TabItem.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 4/5/25.
//


enum TabItem: CaseIterable {
    
    case discover
    case upcoming
    case favorite
    
    var navigationTitle: String{
        switch self {
        case .discover:
            return "Discover"
        case .upcoming:
            return "Upcoming Games"
        case .favorite:
            return "Favorites"
        }
    }
    
    var title: String{
        switch self {
        case .discover:
            return "Discover"
        case .upcoming:
            return "Upcoming"
        case .favorite:
            return "Favorites"
        }
    }
    
    var iconName: String{
        switch self {
        case .discover:
            return "binoculars.fill"
        case .upcoming:
            return "calendar"
        case .favorite:
            return "star.fill"
        }
    }
}
