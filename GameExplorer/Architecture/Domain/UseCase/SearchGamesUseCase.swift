//
//  SearchGamesUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/4/25.
//

import Foundation

struct SearchGamesUseCase {
    
    let repository: GameRepository

    func execute(searchQuery: String, offset: Int, limit: Int) async throws -> [Game] {
        let gameEntities = try await repository.searchGames(searchQuery: searchQuery, offset: offset, limit: limit)
        return gameEntities.map { Game.from(entity: $0) }
    }
}
