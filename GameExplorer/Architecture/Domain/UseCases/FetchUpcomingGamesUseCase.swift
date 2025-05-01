//
//  FetchUpcomingGamesUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

struct FetchUpcomingGamesUseCase {
    
    let repository: GameRepository

    func execute() async throws -> [Game] {
        let gameEntities: [GameEntity] = try await repository.fetchUpcomingGames()
        return gameEntities.map { Game.from(entity: $0) }
    }
}
