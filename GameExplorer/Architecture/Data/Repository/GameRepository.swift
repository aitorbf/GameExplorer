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
    private let apiClient = IGDBClient()
    
    func fetchUpcomingGames() async throws -> [GameEntity] {
        try await apiClient.fetchUpcomingGames()
    }
    
    func searchGames(searchQuery: String, offset: Int, limit: Int) async throws -> [GameEntity] {
        try await apiClient.searchGames(searchQuery: searchQuery, offset: offset, limit: limit)
    }
    
    func fetchGame(withId id: String) async throws -> GameEntity? {
        try await apiClient.fetchGame(withId: id)
    }
}

#if DEBUG
final class MockGameRepository: GameRepository {
    
    private let allGames: [GameEntity]
        
        init(games: [GameEntity]? = nil) {
            self.allGames = games ?? [
                .mock(
                    id: "1",
                    name: "The Legend of Zelda: Breath of the Wild"),
                .mock(
                    id: "2",
                    name: "The Witcher 3: Wild Hunt"),
                .mock(
                    id: "3",
                    name: "Red Dead Redemption 2"),
                .mock(
                    id: "4",
                    name: "God of War Ragnarök"),
                .mock(
                    id: "5",
                    name: "Elden Ring"),
                .mock(
                    id: "6",
                    name: "Halo Infinite"),
                .mock(
                    id: "7",
                    name: "Grand Theft Auto V"),
                .mock(
                    id: "8",
                    name: "Final Fantasy VII Remake"),
                .mock(
                    id: "9",
                    name: "Resident Evil 4"),
                .mock(
                    id: "10",
                    name: "Super Mario Odyssey")
            ]
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
#endif
