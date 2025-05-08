//
//  FavoritesRepository.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 7/5/25.
//

import Foundation

protocol FavoritesRepository {
    
    func add(_ game: GameEntity) throws
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
    
    func add(_ game: GameEntity) throws {
        try localDataSource.add(game)
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

