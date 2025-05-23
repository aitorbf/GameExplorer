//
//  FetchUpcomingGamesUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

protocol FetchUpcomingGamesUseCase {
    func execute() async throws -> [Game]
}

struct FetchUpcomingGamesUseCaseImpl: FetchUpcomingGamesUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Game] {
        let gameEntities: [GameEntity] = try await repository.fetchUpcomingGames()
        return gameEntities.map { GameMapper.map($0) }
    }
}
