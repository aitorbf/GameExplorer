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
    let releaseDate: Date
    let coverUrl: URL?
    let videoUrl: URL?
    
    static func from(entity: GameEntity) -> Game {
        Game(
            id: UUID(),
            gameId: entity.id,
            name: entity.name,
            releaseDate: entity.firstReleaseDate,
            coverUrl: URL(string: entity.coverUrl ?? ""),
            videoUrl: URL(string: entity.videoUrl ?? "")
        )
    }
}

extension Game {
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Mock Game",
        releaseDate: Date = Date(),
        coverUrl: URL? = URL(string: "https://picsum.photos/seed/picsum/200/300"),
        videoUrl: URL? = URL(string: "https://www.youtube.com/watch?v=D0UnqGm_miA")
    ) -> Game {
        Game(
            id: UUID(),
            gameId: id,
            name: name,
            releaseDate: releaseDate,
            coverUrl: coverUrl,
            videoUrl: videoUrl
        )
    }
}
