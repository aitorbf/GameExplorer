//
//  SearchGameCard.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/4/25.
//


import SwiftUI

struct SearchGameCard: View {
    let game: Game

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: game.coverUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(Color(.surface).opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.headline)
                    .foregroundColor(Color(.textPrimary))
                
                Text(game.releaseDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(Color(.textSecondary))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SearchGameCard(game: Game.mock())
}
