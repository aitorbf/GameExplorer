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
    var namespace: Namespace.ID?
    
    var body: some View {
        KFImage.url(game.coverUrl)
            .placeholder {
                Rectangle()
                    .fill(.shadowPurple.opacity(0.3))
                    .overlay {
                        Image("Gamepad")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
            }
            .resizable()
            .scaledToFit()
            .cornerRadius(12)
            .ifLet(namespace) { view, namespace in
                view
                    .matchedGeometryEffect(id: game.id, in: namespace)
            }
    }
}

#Preview {
    GridGameCard(game: Game.mock())
        .background(.customBackground)
}
