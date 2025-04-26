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
    var firstReleaseDate: Date
    var coverUrl: String?
    var videoUrl: String?
}

extension GameEntity {
    
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Mock Game",
        releaseDate: Date = Date(),
        coverUrl: String? = "https://picsum.photos/seed/picsum/200/300",
        videoUrl: String? = "https://www.youtube.com/watch?v=D0UnqGm_miA"
    ) -> GameEntity {
        GameEntity(
            id: id,
            name: name,
            firstReleaseDate: releaseDate,
            coverUrl: coverUrl,
            videoUrl: videoUrl
        )
    }
}
