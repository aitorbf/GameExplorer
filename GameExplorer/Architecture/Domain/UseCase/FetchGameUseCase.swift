//
//  FetchGameUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 4/5/25.
//

import Foundation

struct FetchGameUseCase {
    
    let repository: GameRepository

    func execute(gameId: String) async throws -> Game? {
        if let gameEntity = try await repository.fetchGame(withId: gameId) {
            return Game.from(entity: gameEntity)
        }
        
        return nil
    }
}
