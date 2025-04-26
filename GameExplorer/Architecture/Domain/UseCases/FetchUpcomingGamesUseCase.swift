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
        return gameEntities.map {
            Game.from(entity: $0)
        }
    }
}

#if DEBUG
extension FetchUpcomingGamesUseCase {
    func executeMock() async throws -> [Game] {
        return [
            Game.mock(name: "The Legend of Zelda: Breath of the Wild"),
            Game.mock(name: "The Witcher 3: Wild Hunt"),
            Game.mock(name: "Red Dead Redemption 2"),
            Game.mock(name: "God of War Ragnarök"),
            Game.mock(name: "Elden Ring"),
            Game.mock(name: "Halo Infinite"),
            Game.mock(name: "Grand Theft Auto V"),
            Game.mock(name: "Final Fantasy VII Remake"),
            Game.mock(name: "Resident Evil 4"),
            Game.mock(name: "Super Mario Odyssey")
        ]
    }
}
#endif
