//
//  GameEntity.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/4/25.
//

import Foundation
import SwiftData

@Model
final class GameEntity: Identifiable {
    
    @Attribute(.unique) var id: String
    var name: String
    var summary: String?
    var firstReleaseDate: Date
    var rating: Double?
    var coverUrl: String?
    var videoId: String?
    var screenshotUrls: [String]
    var genres: [String]
    var platforms: [String]
    var companies: [String]
    
    init(
        id: String,
        name: String,
        summary: String? = nil,
        firstReleaseDate: Date,
        rating: Double? = nil,
        coverUrl: String? = nil,
        videoId: String? = nil,
        screenshotUrls: [String] = [],
        genres: [String] = [],
        platforms: [String] = [],
        companies: [String] = []
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.firstReleaseDate = firstReleaseDate
        self.rating = rating
        self.coverUrl = coverUrl
        self.videoId = videoId
        self.screenshotUrls = screenshotUrls
        self.genres = genres
        self.platforms = platforms
        self.companies = companies
    }
}

extension GameEntity {
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Game Mock",
        summary: String? = "An epic adventure through a richly detailed world, filled with danger and discovery.",
        releaseDate: Date = Date(),
        rating: Double? = 9.5,
        coverUrl: String? = "https://picsum.photos/seed/cover/300/450",
        videoId: String? = "D0UnqGm_miA",
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
            videoId: videoId,
            screenshotUrls: screenshotUrls,
            genres: genres,
            platforms: platforms,
            companies: companies
        )
    }
}
