//
//  IGDBClient.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation
import IGDB_SWIFT_API

final class IGDBClient {
    private let clientID = Bundle.main.infoDictionary?["IGDB_CLIENT_ID"] as? String
    
    func fetchUpcomingGames() async throws -> [GameEntity] {
        try await IGDBAuthManager.shared.ensureValidToken()
        
        guard let accessToken = IGDBAuthManager.shared.currentAccessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let wrapper = IGDBWrapper(clientID: clientID ?? "", accessToken: accessToken)
        let now = Int(Date().timeIntervalSince1970)
        let query = APICalypse()
            .fields(fields: "id,name,first_release_date,cover.image_id,videos.video_id")
            .where(query: "first_release_date > \(now) & hypes != null")
            .sort(field: "hypes", order: .DESCENDING)
            .limit(value: 100)
        
        return try await withCheckedThrowingContinuation { continuation in
            wrapper.games(apiCalypse: query, result: { games in
                let gameEntities = games.map { game in
                    GameEntityMapper.mapIGDBGame(game: game)
                }
                continuation.resume(returning: gameEntities)
            }, errorResponse: { error in
                continuation.resume(throwing: error)
            })
        }
    }
    
    func searchGames(searchQuery: String, offset: Int, limit: Int) async throws -> [GameEntity] {
        try await IGDBAuthManager.shared.ensureValidToken()
        
        guard let accessToken = IGDBAuthManager.shared.currentAccessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let wrapper = IGDBWrapper(clientID: clientID ?? "", accessToken: accessToken)
        var query = APICalypse()
            .fields(fields: "name,first_release_date,cover.image_id,videos.video_id,hypes")
            .limit(value: Int32(limit))
            .offset(value: Int32(offset))
        
        if !searchQuery.isEmpty {
            query = query.search(searchQuery: searchQuery)
        } else {
            query = query.sort(field: "hypes", order: .DESCENDING)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            wrapper.games(apiCalypse: query, result: { games in
                let gameEntities = games.map { game in
                    GameEntityMapper.mapIGDBGame(game: game)
                }
                continuation.resume(returning: gameEntities)
            }, errorResponse: { error in
                continuation.resume(throwing: error)
            })
        }
    }
    
    func fetchGame(withId id: String) async throws -> GameEntity? {
        try await IGDBAuthManager.shared.ensureValidToken()
        
        guard let accessToken = IGDBAuthManager.shared.currentAccessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let wrapper = IGDBWrapper(clientID: clientID ?? "", accessToken: accessToken)
        let query = APICalypse()
            .fields(fields: "name,summary,first_release_date,cover.image_id,videos.video_id,screenshots.image_id,genres.name,platforms.name,involved_companies.company.name,total_rating")
            .where(query: "id = \(id)")
        
        return try await withCheckedThrowingContinuation { continuation in
            wrapper.games(apiCalypse: query, result: { games in
                let gameEntity = games.first.map { game in
                    GameEntityMapper.mapIGDBGame(game: game)
                }
                continuation.resume(returning: gameEntity)
            }, errorResponse: { error in
                continuation.resume(throwing: error)
            })
        }
    }
}
