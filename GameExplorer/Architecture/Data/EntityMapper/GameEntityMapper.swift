//
//  GameEntityMapper.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 4/5/25.
//

import Foundation
import IGDB_SWIFT_API

struct GameEntityMapper {
    
    private static let youtubeUrl = "https://www.youtube.com/watch?v="
    
    static func mapIGDBGame(game: Proto_Game) -> GameEntity {
        .init(
                id: String(game.id),
                name: game.name,
                summary: game.summary,
                firstReleaseDate: Date(timeIntervalSince1970: game.firstReleaseDate.timeIntervalSince1970),
                rating: game.totalRating,
                coverUrl: imageBuilder(imageID: game.cover.imageID, size: .COVER_BIG, imageType: .PNG),
                videoUrl: "\(self.youtubeUrl)\(game.videos.first?.videoID ?? "")",
                screenshotUrls: game.screenshots.compactMap { imageBuilder(imageID: $0.imageID, size: .SCREENSHOT_BIG, imageType: .PNG) },
                genres: game.genres.map { $0.name },
                platforms: game.platforms.map { $0.name },
                companies: game.involvedCompanies.map { $0.company.name }
            )
    }
}
