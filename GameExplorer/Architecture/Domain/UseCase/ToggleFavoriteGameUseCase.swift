//
//  ToggleFavoriteGameUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import Foundation

struct ToggleFavoriteGameUseCase {
    
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute(game: Game) throws {
        if repository.isFavorite(game.gameId) {
            try repository.remove(game.gameId)
        } else {
            try repository.add(game.toEntity())
        }
    }
}
