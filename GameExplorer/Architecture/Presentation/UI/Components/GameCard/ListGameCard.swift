//
//  ListGameCard.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/4/25.
//


import SwiftUI
import Kingfisher

struct ListGameCard: View {
    
    let game: Game
    var namespace: Namespace.ID?

    var body: some View {
        HStack(spacing: 12) {
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
                .frame(maxWidth: 150)
                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                .ifLet(namespace) { view, namespace in
                    view
                        .matchedGeometryEffect(id: game.gameId, in: namespace)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.title2)
                    .lineLimit(2)
                    .foregroundColor(.textPrimary)
                
                Text(game.companies.first ?? "")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, 8)
                
                Label(game.rating, systemImage: "star.fill")
                    .font(.subheadline.bold())
                    .foregroundStyle(.textPrimary)
            }
            
            Spacer()
        }
        .background(.surface)
        .cornerRadius(12)
        .padding(.vertical, 8)
    }
}

#Preview {
    ListGameCard(game: Game.mock())
        .background(.customBackground)
}
