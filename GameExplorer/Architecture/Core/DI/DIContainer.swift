//
//  DIContainer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation
import SwiftData

@MainActor
protocol DIContainerProtocol {
    func discoverViewModel() -> DiscoverViewModel
    func upcomingGamesViewModel() -> UpcomingGamesViewModel
    func favoritesViewModel() -> FavoritesViewModel
    func gameDetailViewModel(gameId: String) -> GameDetailViewModel
}

@MainActor
final class DIContainer: DIContainerProtocol {
    
    static let shared: DIContainer = DIContainer()
    
    private let modelContext: ModelContext
    private let gameRepository: GameRepository
    private let favoritesRepository: FavoritesRepository

    private let searchGamesUseCase: SearchGamesUseCase
    private let fetchUpcomingGamesUseCase: FetchUpcomingGamesUseCase
    private let getFavoriteGamesUseCase: GetFavoriteGamesUseCase
    private let fetchGameUseCase: FetchGameUseCase
    private let isGameFavoriteUseCase: IsGameFavoriteUseCase
    private let toggleFavoriteGameUseCase: ToggleFavoriteGameUseCase

    private init() {
        self.modelContext = SwiftDataManager.shared.modelContext

        self.gameRepository = GameRepositoryImpl(remoteDataSource: IGDBRemoteDataSourceImpl())
        self.favoritesRepository = FavoritesRepositoryImpl(
            localDataSource: FavoritesLocalDataSourceImpl(context: modelContext)
        )
        
        self.searchGamesUseCase = SearchGamesUseCaseImpl(repository: gameRepository)
        self.fetchUpcomingGamesUseCase = FetchUpcomingGamesUseCaseImpl(repository: gameRepository)
        self.getFavoriteGamesUseCase = GetFavoriteGamesUseCaseImpl(repository: favoritesRepository)
        self.fetchGameUseCase = FetchGameUseCaseImpl(repository: gameRepository)
        self.isGameFavoriteUseCase = IsGameFavoriteUseCaseImpl(repository: favoritesRepository)
        self.toggleFavoriteGameUseCase = ToggleFavoriteGameUseCaseImpl(repository: favoritesRepository)
    }

    func discoverViewModel() -> DiscoverViewModel {
        DiscoverViewModel(searchGamesUseCase: searchGamesUseCase)
    }

    func upcomingGamesViewModel() -> UpcomingGamesViewModel {
        UpcomingGamesViewModel(fetchUpcomingGamesUseCase: fetchUpcomingGamesUseCase)
    }
    
    func favoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(getFavoriteGamesUseCase: getFavoriteGamesUseCase)
    }
    
    func gameDetailViewModel(gameId: String) -> GameDetailViewModel {
        GameDetailViewModel(
            gameId: gameId,
            fetchGameUseCase: fetchGameUseCase,
            isGameFavoriteUseCase: isGameFavoriteUseCase,
            toggleFavoriteGameUseCase: toggleFavoriteGameUseCase
        )
    }
}

@MainActor
final class MockDIContainer: DIContainerProtocol {
    
    static let shared = MockDIContainer()
    
    private let modelContext: ModelContext
    private let gameRepository: GameRepository
    private let favoritesRepository: FavoritesRepository

    private let searchGamesUseCase: SearchGamesUseCase
    private let fetchUpcomingGamesUseCase: FetchUpcomingGamesUseCase
    private let getFavoriteGamesUseCase: GetFavoriteGamesUseCase
    private let fetchGameUseCase: FetchGameUseCase
    private let isGameFavoriteUseCase: IsGameFavoriteUseCase
    private let toggleFavoriteGameUseCase: ToggleFavoriteGameUseCase

    private init() {
        
        self.modelContext = SwiftDataManager.test.modelContext

        self.gameRepository = MockGameRepository()
        self.favoritesRepository = FavoritesRepositoryImpl.mock(preloadedGames: GameEntity.mockList())

        self.searchGamesUseCase = SearchGamesUseCaseImpl(repository: gameRepository)
        self.fetchUpcomingGamesUseCase = FetchUpcomingGamesUseCaseImpl(repository: gameRepository)
        self.getFavoriteGamesUseCase = GetFavoriteGamesUseCaseImpl(repository: favoritesRepository)
        self.fetchGameUseCase = FetchGameUseCaseImpl(repository: gameRepository)
        self.isGameFavoriteUseCase = IsGameFavoriteUseCaseImpl(repository: favoritesRepository)
        self.toggleFavoriteGameUseCase = ToggleFavoriteGameUseCaseImpl(repository: favoritesRepository)
    }

    func discoverViewModel() -> DiscoverViewModel {
        DiscoverViewModel(searchGamesUseCase: searchGamesUseCase)
    }

    func upcomingGamesViewModel() -> UpcomingGamesViewModel {
        UpcomingGamesViewModel(fetchUpcomingGamesUseCase: fetchUpcomingGamesUseCase)
    }

    func favoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(getFavoriteGamesUseCase: getFavoriteGamesUseCase)
    }

    func gameDetailViewModel(gameId: String) -> GameDetailViewModel {
        GameDetailViewModel(
            gameId: gameId,
            fetchGameUseCase: fetchGameUseCase,
            isGameFavoriteUseCase: isGameFavoriteUseCase,
            toggleFavoriteGameUseCase: toggleFavoriteGameUseCase
        )
    }
}
