//
//  Coordinator.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 26/4/25.
//


import SwiftUI

enum Route: Hashable {
    case gameDetail(gameId: String)
}

final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(route: Route) -> some View {
        switch route {
        case .gameDetail(let gameId):
            GameDetailView(
                viewModel: DIContainer.shared.gameDetailViewModel(gameId: gameId)
            )
        }
    }
}
