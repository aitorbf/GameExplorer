//
//  GameMapper.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/5/25.
//

import Foundation

struct GameMapper {
    
    static func map(_ entity: GameEntity) -> Game {
        .init(
            id: entity.id,
            name: entity.name,
            summary: entity.summary,
            releaseDate: entity.firstReleaseDate,
            rating: String(format: "%.1f", (entity.rating ?? 0.0) / 10),
            coverUrl: URL(string: entity.coverUrl ?? ""),
            videoId: entity.videoId,
            screenshotUrls: entity.screenshotUrls.compactMap { URL(string: $0) },
            genres: entity.genres,
            platforms: entity.platforms,
            companies: entity.companies
        )
    }
}
