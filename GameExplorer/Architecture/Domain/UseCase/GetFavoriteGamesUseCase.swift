//
//  GetFavoriteGamesUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import Foundation

struct GetFavoriteGamesUseCase {
    
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute() -> [Game] {
        repository.getFavorites().map { gameEntity in
            Game.from(entity: gameEntity)
        }
    }
}
