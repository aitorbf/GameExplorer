//
//  Coordinator.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 26/4/25.
//


import SwiftUI

enum Screen: Identifiable, Hashable {
    
    case gameDetail(gameId: String)
    
    var id: Self { return self }
}

protocol CoordinatorProtocol: ObservableObject {
    
    var path: NavigationPath { get set }
    
    func push(_ screen:  Screen)
    func pop()
    func popToRoot()
}

final class Coordinator: CoordinatorProtocol {
    
    @Published var path = NavigationPath()
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @MainActor @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .gameDetail(let gameId):
            GameDetailView(
                viewModel: DIContainer.shared.gameDetailViewModel(gameId: gameId)
            )
        }
    }
}
