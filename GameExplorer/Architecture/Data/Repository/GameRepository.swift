//
//  GameRepository.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

protocol GameRepository {
    func fetchUpcomingGames() async throws -> [GameEntity]
    func searchGames(searchQuery: String, offset: Int, limit: Int) async throws -> [GameEntity]
    func fetchGame(withId id: String) async throws -> GameEntity?
}

final class GameRepositoryImpl: GameRepository {
    
    private let remoteDataSource: IGDBRemoteDataSource
    
    init(remoteDataSource: IGDBRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchUpcomingGames() async throws -> [GameEntity] {
        try await remoteDataSource.fetchUpcomingGames()
    }
    
    func searchGames(searchQuery: String, offset: Int, limit: Int) async throws -> [GameEntity] {
        try await remoteDataSource.searchGames(searchQuery: searchQuery, offset: offset, limit: limit)
    }
    
    func fetchGame(withId id: String) async throws -> GameEntity? {
        try await remoteDataSource.fetchGame(withId: id)
    }
}

#if DEBUG
final class MockGameRepository: GameRepository {
    
    private let allGames: [GameEntity]
    
    init(games: [GameEntity]? = nil) {
        self.allGames = games ?? GameEntity.mockList()
    }
    
    func fetchUpcomingGames() async throws -> [GameEntity] {
        return allGames
    }
    
    func searchGames(searchQuery: String, offset: Int, limit: Int) async throws -> [GameEntity] {
        var filteredGames = allGames
        if !searchQuery.isEmpty {
            filteredGames = allGames.filter {
                $0.name.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        let start = min(offset, filteredGames.count)
        let end = min(start + limit, filteredGames.count)
        return Array(filteredGames[start..<end])
    }
    
    func fetchGame(withId id: String) async throws -> GameEntity? {
        return allGames.first { $0.id == id }
    }
}

final class ThrowingGameRepository: GameRepository {
    
    enum TestError: Error { case fetchFailed }
    
    func fetchUpcomingGames() async throws -> [GameEntity] {
        throw TestError.fetchFailed
    }
    
    func searchGames(searchQuery: String, offset: Int, limit: Int) async throws -> [GameEntity] {
        throw TestError.fetchFailed
    }
    
    func fetchGame(withId id: String) async throws -> GameEntity? {
        throw TestError.fetchFailed
    }
}
#endif
