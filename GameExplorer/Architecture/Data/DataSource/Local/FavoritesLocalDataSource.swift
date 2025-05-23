//
//  FavoritesLocalDataSource.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 7/5/25.
//

import Foundation
import SwiftData

protocol FavoritesLocalDataSource {
    func add(_ game: GameEntity) throws
    func remove(_ gameId: String) throws
    func isFavorite(_ gameId: String) -> Bool
    func getFavorites() -> [GameEntity]
    func getGame(by id: String) -> GameEntity?
}

final class FavoritesLocalDataSourceImpl: FavoritesLocalDataSource {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func add(_ game: GameEntity) throws {
        guard !isFavorite(game.id) else { return }
        context.insert(game)
        try context.save()
    }
    
    func remove(_ gameId: String) throws {
        if let existing = getGame(by: gameId) {
            context.delete(existing)
            try context.save()
        }
    }
    
    func isFavorite(_ gameId: String) -> Bool {
        getGame(by: gameId) != nil
    }
    
    func getFavorites() -> [GameEntity] {
        let descriptor = FetchDescriptor<GameEntity>(sortBy: [SortDescriptor(\.firstReleaseDate, order: .reverse)])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func getGame(by id: String) -> GameEntity? {
        let descriptor = FetchDescriptor<GameEntity>(
            predicate: #Predicate { $0.id == id }
        )
        
        return try? context.fetch(descriptor).first
    }
}
