//
//  GameRepository.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

protocol GameRepository {
    func fetchUpcomingGames() async throws -> [GameEntity]
}

class GameRepositoryImpl: GameRepository {
    private let apiClient = IGDBClient()

    func fetchUpcomingGames() async throws -> [GameEntity] {
        return try await apiClient.fetchUpcomingGames()
    }
}

#if DEBUG
final class MockGameRepository: GameRepository {
    func fetchUpcomingGames() async throws -> [GameEntity] {
        return [
            GameEntity.mock(id: "1", name: "The Legend of Zelda: Breath of the Wild"),
            GameEntity.mock(id: "2", name: "The Witcher 3: Wild Hunt"),
            GameEntity.mock(id: "3", name: "Red Dead Redemption 2"),
            GameEntity.mock(id: "4", name: "God of War Ragnarök"),
            GameEntity.mock(id: "5", name: "Elden Ring"),
            GameEntity.mock(id: "6", name: "Halo Infinite"),
            GameEntity.mock(id: "7", name: "Grand Theft Auto V"),
            GameEntity.mock(id: "8", name: "Final Fantasy VII Remake"),
            GameEntity.mock(id: "9", name: "Resident Evil 4"),
            GameEntity.mock(id: "10", name: "Super Mario Odyssey")
        ]
    }
}
#endif
