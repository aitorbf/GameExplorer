//
//  GridGameCard.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/5/25.
//

import SwiftUI
import Kingfisher

struct GridGameCard: View {
    
    let game: Game
    
    var body: some View {
        KFImage.url(game.coverUrl)
            .placeholder {
                Rectangle()
                    .fill(.shadowPurple.opacity(0.3))
            }
            .resizable()
            .scaledToFit()
            .cornerRadius(12)
    }
}

#Preview {
    GridGameCard(game: Game.mock())
        .background(.customBackground)
}
