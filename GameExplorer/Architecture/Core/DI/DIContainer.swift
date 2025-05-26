//
//  DIContainer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Swinject
import SwiftData

@MainActor
final class DIContainer {
    
    static let shared = DIContainer()

    private let container: Container

    private init() {
        container = Container()
        
        // MARK: - Swift Data Model Context
        container.register(ModelContext.self) { _ in
            SwiftDataManager.shared.modelContext
        }
        
        // MARK: - Repositories
        container.register(GameRepository.self) { resolver in
            GameRepositoryImpl(remoteDataSource: IGDBRemoteDataSourceImpl())
        }
        
        container.register(FavoritesRepository.self) { resolver in
            let context = resolver.resolve(ModelContext.self)!
            let localDataSource = FavoritesLocalDataSourceImpl(context: context)
            return FavoritesRepositoryImpl(localDataSource: localDataSource)
        }
        
        // MARK: - Use Cases
        container.register(SearchGamesUseCase.self) { resolver in
            SearchGamesUseCaseImpl(repository: resolver.resolve(GameRepository.self)!)
        }
        container.register(FetchUpcomingGamesUseCase.self) { resolver in
            FetchUpcomingGamesUseCaseImpl(repository: resolver.resolve(GameRepository.self)!)
        }
        container.register(GetFavoriteGamesUseCase.self) { resolver in
            GetFavoriteGamesUseCaseImpl(repository: resolver.resolve(FavoritesRepository.self)!)
        }
        container.register(FetchGameUseCase.self) { resolver in
            FetchGameUseCaseImpl(repository: resolver.resolve(GameRepository.self)!)
        }
        container.register(IsGameFavoriteUseCase.self) { resolver in
            IsGameFavoriteUseCaseImpl(repository: resolver.resolve(FavoritesRepository.self)!)
        }
        container.register(ToggleFavoriteGameUseCase.self) { resolver in
            ToggleFavoriteGameUseCaseImpl(repository: resolver.resolve(FavoritesRepository.self)!)
        }
        
        // MARK: - ViewModels
        container.register(DiscoverViewModel.self) { resolver in
            DiscoverViewModel(searchGamesUseCase: resolver.resolve(SearchGamesUseCase.self)!)
        }
        container.register(UpcomingGamesViewModel.self) { resolver in
            UpcomingGamesViewModel(fetchUpcomingGamesUseCase: resolver.resolve(FetchUpcomingGamesUseCase.self)!)
        }
        container.register(FavoritesViewModel.self) { resolver in
            FavoritesViewModel(getFavoriteGamesUseCase: resolver.resolve(GetFavoriteGamesUseCase.self)!)
        }
        container.register(GameDetailViewModel.self) { (resolver, gameId: String) in
            GameDetailViewModel(
                gameId: gameId,
                fetchGameUseCase: resolver.resolve(FetchGameUseCase.self)!,
                isGameFavoriteUseCase: resolver.resolve(IsGameFavoriteUseCase.self)!,
                toggleFavoriteGameUseCase: resolver.resolve(ToggleFavoriteGameUseCase.self)!
            )
        }
    }
    
    func getDiscoverViewModel() -> DiscoverViewModel {
        container.resolve(DiscoverViewModel.self)!
    }
    
    func getUpcomingGamesViewModel() -> UpcomingGamesViewModel {
        container.resolve(UpcomingGamesViewModel.self)!
    }
    
    func getFavoritesViewModel() -> FavoritesViewModel {
        container.resolve(FavoritesViewModel.self)!
    }
    
    func getGameDetailViewModel(gameId: String) -> GameDetailViewModel {
        container.resolve(GameDetailViewModel.self, argument: gameId)!
    }
}

// MARK: - Mock Container for Testing and Previews

extension DIContainer {
    
    static var mock: DIContainer {
        let container = DIContainer()
        
        container.container.register(ModelContext.self) { _ in
            SwiftDataManager.test.modelContext
        }
        
        container.container.register(GameRepository.self) { _ in
            MockGameRepository()
        }
        
        container.container.register(FavoritesRepository.self) { resolver in
            FavoritesRepositoryImpl.mock(preloadedGames: GameEntity.mockList())
        }
        
        return container
    }
}
