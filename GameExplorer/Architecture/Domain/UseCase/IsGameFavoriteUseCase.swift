//
//  IsGameFavoriteUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import Foundation

struct IsGameFavoriteUseCase {
    
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute(gameId: String) -> Bool {
        repository.isFavorite(gameId)
    }
}
