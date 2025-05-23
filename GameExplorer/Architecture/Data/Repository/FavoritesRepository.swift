//
//  FavoritesRepository.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 7/5/25.
//

import Foundation

protocol FavoritesRepository {
    func add(_ game: Game) throws
    func remove(_ gameId: String) throws
    func isFavorite(_ gameId: String) -> Bool
    func getFavorites() -> [GameEntity]
    func getGame(by id: String) -> GameEntity?
}

final class FavoritesRepositoryImpl: FavoritesRepository {
    
    private let localDataSource: FavoritesLocalDataSource
    
    init(localDataSource: FavoritesLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func add(_ game: Game) throws {
        try localDataSource.add(GameEntityMapper.map(game))
    }
    
    func remove(_ gameId: String) throws {
        try localDataSource.remove(gameId)
    }
    
    func isFavorite(_ gameId: String) -> Bool {
        localDataSource.isFavorite(gameId)
    }
    
    func getFavorites() -> [GameEntity] {
        localDataSource.getFavorites()
    }
    
    func getGame(by id: String) -> GameEntity? {
        localDataSource.getGame(by: id)
    }
}

#if DEBUG
extension FavoritesRepositoryImpl {
    
    @MainActor
    static func mock(preloadedGames: [GameEntity] = []) -> FavoritesRepository {
        let context = SwiftDataManager.test.modelContext
        
        preloadedGames.forEach { context.insert($0) }
        
        return FavoritesRepositoryImpl(
            localDataSource: FavoritesLocalDataSourceImpl(context: context)
        )
    }
}
#endif
