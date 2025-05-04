//
//  UpcomingGameCard.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//


import SwiftUI

struct UpcomingGameCard: View {
    
    let game: Game
    var playVideo: Bool
    
    @State private var contentSize: CGSize = .zero
    private let marqueeDelay: Double = 1.2

    var body: some View {
        ZStack {
            if let videoUrl = game.videoUrl, playVideo {
                VideoPlayer(url: videoUrl, width: contentSize.width)
            } else {
                gameCover
                gameInfo
            }
        }
        .background(Color(.background))
        .cornerRadius(12)
        .shadow(color: Color(.shadowBlue), radius: 5, x: 5, y: 5)
        .shadow(color: Color(.shadowPurple), radius: 5, x: -5, y: -5)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: {
            contentSize = $0
        }
    }
    
    var gameCover: some View {
        ZStack {
            AsyncImage(url: game.coverUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color(.background).opacity(0.3))
            }
            
            Image(systemName: "play.fill")
                .resizable()
                .foregroundColor(Color(.textPrimary))
                .frame(width: 24, height: 24)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.surface))
                }
                .opacity(0.8)
        }
        .frame(height: 200)
        .clipped()
    }
    
    var gameInfo: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                TextMarquee(
                    text: AttributedString(game.name),
                    font: .headline,
                    startDelay: marqueeDelay
                )
                .foregroundStyle(Color(.textPrimary))
                
                Spacer()
                
                Text(game.releaseDate, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(16)
            .background(Color(.surface).opacity(0.9))
        }
    }
}

#Preview {
    UpcomingGameCard(game: Game.mock(), playVideo: false)
        .frame(height: 200)
        .padding()
}
