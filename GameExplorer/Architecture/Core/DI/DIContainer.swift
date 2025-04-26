//
//  DIContainer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

final class DIContainer {
    private let gameRepository: GameRepository

    init(gameRepository: GameRepository = GameRepositoryImpl()) {
        self.gameRepository = gameRepository
    }

    @MainActor
    func upcomingGamesViewModel() -> UpcomingGamesViewModel {
        let fetchUpcomingGamesUseCase = FetchUpcomingGamesUseCase(repository: gameRepository)
        return UpcomingGamesViewModel(fetchUpcomingGamesUseCase: fetchUpcomingGamesUseCase)
    }
}

#if DEBUG
extension DIContainer {
    static var mock: DIContainer {
        DIContainer(gameRepository: MockGameRepository())
    }
}
#endif
