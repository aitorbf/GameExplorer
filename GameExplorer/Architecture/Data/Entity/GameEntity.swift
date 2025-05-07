//
//  GameEntity.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation

struct GameEntity: Identifiable {
    
    var id: String
    var name: String
    var summary: String?
    var firstReleaseDate: Date
    var rating: Double?
    var coverUrl: String?
    var videoUrl: String?
    var screenshotUrls: [String]
    var genres: [String]
    var platforms: [String]
    var companies: [String]
}

extension GameEntity {
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Game Mock",
        summary: String? = "An epic adventure through a richly detailed world, filled with danger and discovery.",
        releaseDate: Date = Date(),
        rating: Double? = 9.5,
        coverUrl: String? = "https://picsum.photos/seed/cover/300/450",
        videoUrl: String? = "https://www.youtube.com/watch?v=D0UnqGm_miA",
        screenshotUrls: [String] = [
            "https://picsum.photos/seed/screenshot1/600/400",
            "https://picsum.photos/seed/screenshot2/600/400",
            "https://picsum.photos/seed/screenshot3/600/400"
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
            id: id,
            name: name,
            summary: summary,
            firstReleaseDate: releaseDate,
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
