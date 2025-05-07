//
//  DIContainer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private let gameRepository: GameRepository

    private init(gameRepository: GameRepository = GameRepositoryImpl()) {
        self.gameRepository = gameRepository
    }

    func discoverViewModel() -> DiscoverViewModel {
        let searchGamesUseCase = SearchGamesUseCase(repository: gameRepository)
        return DiscoverViewModel(searchGamesUseCase: searchGamesUseCase)
    }

    func upcomingGamesViewModel() -> UpcomingGamesViewModel {
        let fetchUpcomingGamesUseCase = FetchUpcomingGamesUseCase(repository: gameRepository)
        return UpcomingGamesViewModel(fetchUpcomingGamesUseCase: fetchUpcomingGamesUseCase)
    }
    
    func gameDetailViewModel(gameId: String) -> GameDetailViewModel {
        let fetchGameUseCase = FetchGameUseCase(repository: gameRepository)
        return GameDetailViewModel(gameId: gameId, fetchGameUseCase: fetchGameUseCase)
    }
}

#if DEBUG
extension DIContainer {
    static var mock: DIContainer {
        DIContainer(gameRepository: MockGameRepository())
    }
}
#endif
