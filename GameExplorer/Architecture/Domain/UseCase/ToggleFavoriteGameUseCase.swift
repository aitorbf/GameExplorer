//
//  ToggleFavoriteGameUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import Foundation

protocol ToggleFavoriteGameUseCase {
    func execute(game: Game) throws
}

struct ToggleFavoriteGameUseCaseImpl: ToggleFavoriteGameUseCase {
    
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute(game: Game) throws {
        if repository.isFavorite(game.id) {
            try repository.remove(game.id)
        } else {
            try repository.add(game)
        }
    }
}
