//
//  Game.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

struct Game: Identifiable, Equatable, Hashable {
    
    let id: UUID
    let gameId: String
    let name: String
    let summary: String?
    let releaseDate: Date
    let rating: String
    let coverUrl: URL?
    let videoUrl: URL?
    let screenshotUrls: [URL]
    let genres: [String]
    let platforms: [String]
    let companies: [String]
    
    static func from(entity: GameEntity) -> Game {
        Game(
            id: UUID(),
            gameId: entity.id,
            name: entity.name,
            summary: entity.summary,
            releaseDate: entity.firstReleaseDate,
            rating: String(format: "%.1f", (entity.rating ?? 0.0) / 10),
            coverUrl: URL(string: entity.coverUrl ?? ""),
            videoUrl: URL(string: entity.videoUrl ?? ""),
            screenshotUrls: entity.screenshotUrls.compactMap { URL(string: $0) },
            genres: entity.genres,
            platforms: entity.platforms,
            companies: entity.companies
        )
    }
}

extension Game {
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Mock Game",
        summary: String? = "This is a mock summary of an exciting game full of surprises and action.",
        releaseDate: Date = Date(),
        rating: String = "9.5",
        coverUrl: URL? = URL(string: "https://picsum.photos/seed/cover/300/450"),
        videoUrl: URL? = URL(string: "https://www.youtube.com/watch?v=D0UnqGm_miA"),
        screenshotUrls: [URL] = [
            URL(string: "https://picsum.photos/seed/screenshot1/600/400")!,
            URL(string: "https://picsum.photos/seed/screenshot2/600/400")!
        ],
        genres: [String] = [
            "Action",
            "Adventure",
            "RPG"
        ],
        platforms: [String] = [
            "PlayStation 5",
            "Xbox Series X",
            "PC"
        ],
        companies: [String] = [
            "Rockstar Games",
            "Sony Interactive Entertainment",
            "Ubisoft",
            "Electronic Arts",
        ]
    ) -> Self {
        .init(
            id: UUID(),
            gameId: id,
            name: name,
            summary: summary,
            releaseDate: releaseDate,
            rating: rating,
            coverUrl: coverUrl,
            videoUrl: videoUrl,
            screenshotUrls: screenshotUrls,
            genres: genres,
            platforms: platforms,
            companies: companies
        )
    }
}
