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
    private let youtubeUrl = "https://www.youtube.com/embed/"

    func fetchUpcomingGames() async throws -> [GameEntity] {
        try await IGDBAuthManager.shared.ensureValidToken()

        guard let accessToken = IGDBAuthManager.shared.currentAccessToken else {
            throw URLError(.userAuthenticationRequired)
        }

        let wrapper = IGDBWrapper(clientID: clientID ?? "", accessToken: accessToken)
        let now = Int(Date().timeIntervalSince1970)
        let gameQuery = APICalypse()
            .fields(fields: "id,name,first_release_date,cover,videos")
            .where(query: "first_release_date > \(now) & videos != null & cover != null & hypes != null")
            .sort(field: "hypes", order: .DESCENDING)
            .limit(value: 20)

        return try await withCheckedThrowingContinuation { continuation in
            wrapper.games(apiCalypse: gameQuery, result: { games in
                Task {
                    var entities: [GameEntity] = []
                    
                    for game in games {
                        async let coverUrl = self.fetchCoverUrl(for: String(game.cover.id), using: wrapper)
                        async let videoUrl = self.fetchVideoUrl(for: String(game.videos.first?.id ?? .zero), using: wrapper)
                        
                        let entity = GameEntity(
                            id: String(game.id),
                            name: game.name,
                            firstReleaseDate: Date(timeIntervalSince1970: game.firstReleaseDate.timeIntervalSince1970),
                            coverUrl: await coverUrl,
                            videoUrl: await videoUrl
                        )
                        
                        entities.append(entity)
                    }
                    
                    continuation.resume(returning: entities)
                }
            }, errorResponse: { error in
                continuation.resume(throwing: error)
            })
        }
    }
    
    private func fetchCoverUrl(for id: String, using wrapper: IGDBWrapper) async -> String? {
        await withCheckedContinuation { continuation in
            let coverQuery = APICalypse()
                .fields(fields: "image_id")
                .where(query: "id = \(id)")
                .limit(value: 1)

            wrapper.covers(apiCalypse: coverQuery, result: { covers in
                let cover = covers.first
                let imageId = cover?.imageID ?? ""
                let url = imageBuilder(imageID: imageId, size: .SCREENSHOT_HUGE, imageType: .PNG)
                continuation.resume(returning: url)
            }, errorResponse: { _ in
                continuation.resume(returning: nil)
            })
        }
    }
    
    private func fetchVideoUrl(for id: String, using wrapper: IGDBWrapper) async -> String? {
        await withCheckedContinuation { continuation in
            let coverQuery = APICalypse()
                .fields(fields: "video_id")
                .where(query: "id = \(id)")
                .limit(value: 1)

            wrapper.gameVideos(apiCalypse: coverQuery, result: { videos in
                let video = videos.first
                let videoId = video?.videoID ?? ""
                let url = "\(self.youtubeUrl)\(videoId)"
                continuation.resume(returning: url)
            }, errorResponse: { _ in
                continuation.resume(returning: nil)
            })
        }
    }
}
