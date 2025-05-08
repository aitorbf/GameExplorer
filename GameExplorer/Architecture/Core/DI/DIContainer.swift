//
//  DIContainer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation
import SwiftData

@MainActor
final class DIContainer {
    
    static private(set) var shared: DIContainer!
    
    @MainActor
    static func initialize(context: ModelContext) {
        self.shared = DIContainer(modelContext: context)
    }
    
    private let modelContext: ModelContext
    private let gameRepository: GameRepository
    private let favoritesRepository: FavoritesRepository

    private init(
        modelContext: ModelContext,
        gameRepository: GameRepository = GameRepositoryImpl()
    ) {
        self.modelContext = modelContext
        self.gameRepository = gameRepository
        self.favoritesRepository = FavoritesRepositoryImpl(localDataSource: FavoritesLocalDataSourceImpl(context: modelContext))
    }

    func discoverViewModel() -> DiscoverViewModel {
        let searchGamesUseCase = SearchGamesUseCase(repository: gameRepository)
        return DiscoverViewModel(searchGamesUseCase: searchGamesUseCase)
    }

    func upcomingGamesViewModel() -> UpcomingGamesViewModel {
        let fetchUpcomingGamesUseCase = FetchUpcomingGamesUseCase(repository: gameRepository)
        return UpcomingGamesViewModel(fetchUpcomingGamesUseCase: fetchUpcomingGamesUseCase)
    }
    
    func favoritesViewModel() -> FavoritesViewModel {
        let getFavoriteGamesUseCase = GetFavoriteGamesUseCase(repository: favoritesRepository)
        return FavoritesViewModel(getFavoriteGamesUseCase: getFavoriteGamesUseCase)
    }
    
    func gameDetailViewModel(gameId: String) -> GameDetailViewModel {
        let fetchGameUseCase = FetchGameUseCase(repository: gameRepository)
        let isGameFavoriteUseCase = IsGameFavoriteUseCase(repository: favoritesRepository)
        let toggleFavoriteUseCase = ToggleFavoriteGameUseCase(repository: favoritesRepository)
        return GameDetailViewModel(
            gameId: gameId,
            fetchGameUseCase: fetchGameUseCase,
            isGameFavoriteUseCase: isGameFavoriteUseCase,
            toggleFavoriteGameUseCase: toggleFavoriteUseCase
        )
    }
}

#if DEBUG
@MainActor
extension DIContainer {
    @MainActor
    static var mock: DIContainer {
        let context = SwiftDataManager.preview.modelContext
        return DIContainer(
            modelContext: context,
            gameRepository: MockGameRepository()
        )
    }
}
#endif
