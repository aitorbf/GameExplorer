//
//  FavoritesViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published var favorites: [Game] = []
    
    private let getFavoriteGamesUseCase: GetFavoriteGamesUseCase

    init(getFavoriteGamesUseCase: GetFavoriteGamesUseCase) {
        self.getFavoriteGamesUseCase = getFavoriteGamesUseCase
    }

    func loadFavorites() {
        favorites = getFavoriteGamesUseCase.execute()
    }
}

#if DEBUG
extension FavoritesViewModel {
    
    @MainActor
    static func mock() -> FavoritesViewModel {
        MockDIContainer.shared.favoritesViewModel()
    }
}
#endif
