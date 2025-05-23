//
//  GetFavoriteGamesUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import Foundation

protocol GetFavoriteGamesUseCase {
    func execute() -> [Game]
}

struct GetFavoriteGamesUseCaseImpl: GetFavoriteGamesUseCase {
    
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func execute() -> [Game] {
        repository.getFavorites().map { gameEntity in
            GameMapper.map(gameEntity)
        }
    }
}
