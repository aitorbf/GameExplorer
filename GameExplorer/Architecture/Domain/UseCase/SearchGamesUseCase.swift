//
//  SearchGamesUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/4/25.
//

import Foundation

protocol SearchGamesUseCase {
    func execute(searchQuery: String, offset: Int, limit: Int) async throws -> [Game]
}

struct SearchGamesUseCaseImpl: SearchGamesUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(searchQuery: String, offset: Int, limit: Int) async throws -> [Game] {
        let gameEntities = try await repository.searchGames(searchQuery: searchQuery, offset: offset, limit: limit)
        return gameEntities.map { GameMapper.map($0) }
    }
}
