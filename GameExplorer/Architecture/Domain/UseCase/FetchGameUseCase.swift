//
//  FetchGameUseCase.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 4/5/25.
//

import Foundation

protocol FetchGameUseCase {
    func execute(gameId: String) async throws -> Game?
}

struct FetchGameUseCaseImpl: FetchGameUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(gameId: String) async throws -> Game? {
        if let gameEntity = try await repository.fetchGame(withId: gameId) {
            return GameMapper.map(gameEntity)
        }
        
        return nil
    }
}
