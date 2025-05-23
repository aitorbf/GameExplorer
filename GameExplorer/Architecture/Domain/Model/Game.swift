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
    let videoId: String?
    let screenshotUrls: [URL]
    let genres: [String]
    let platforms: [String]
    let companies: [String]
}

extension Game {
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Mock Game",
        summary: String? = "This is a mock summary of an exciting game full of surprises and action.",
        releaseDate: Date = Date(),
        rating: String = "9.5",
        coverUrl: URL? = URL(string: "https://picsum.photos/seed/cover/300/450"),
        videoId: String? = "=D0UnqGm_miA",
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
            videoId: videoId,
            screenshotUrls: screenshotUrls,
            genres: genres,
            platforms: platforms,
            companies: companies
        )
    }
    
    static func mockList(count: Int = 10) -> [Game] {
        (1...count).map { index in
            Self.mock(
                id: "\(index)",
                name: "Game \(index)",
                coverUrl: URL(string: "https://picsum.photos/seed/game\(index)/300/450"),
                videoId: "video\(index)",
                screenshotUrls: [
                    URL(string: "https://picsum.photos/seed/screenshot\(index)-1/600/400")!,
                    URL(string: "https://picsum.photos/seed/screenshot\(index)-2/600/400")!
                ]
            )
        }
    }
}
