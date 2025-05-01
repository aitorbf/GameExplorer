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
    private let youtubeUrl = "https://www.youtube.com/watch?v="
    
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
                    GameEntity(
                        id: String(game.id),
                        name: game.name,
                        firstReleaseDate: Date(timeIntervalSince1970: game.firstReleaseDate.timeIntervalSince1970),
                        coverUrl: imageBuilder(imageID: game.cover.imageID, size: .SCREENSHOT_HUGE, imageType: .PNG),
                        videoUrl: "\(self.youtubeUrl)\(game.videos.first?.videoID ?? "")"
                    )
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
            .fields(fields: "name,first_release_date,cover.image_id,videos.video_id")
            .limit(value: Int32(limit))
            .offset(value: Int32(offset))
        
        if !searchQuery.isEmpty {
            query = query.search(searchQuery: searchQuery)
        } else {
            query = query.sort(field: "first_release_date", order: .DESCENDING)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            wrapper.games(apiCalypse: query, result: { games in
                let gameEntities = games.map { game in
                    GameEntity(
                        id: String(game.id),
                        name: game.name,
                        firstReleaseDate: Date(timeIntervalSince1970: game.firstReleaseDate.timeIntervalSince1970),
                        coverUrl: imageBuilder(imageID: game.cover.imageID, size: .COVER_SMALL, imageType: .PNG),
                        videoUrl: "\(self.youtubeUrl)\(game.videos.first?.videoID ?? "")"
                    )
                }
                continuation.resume(returning: gameEntities)
            }, errorResponse: { error in
                continuation.resume(throwing: error)
            })
        }
    }
}
