//
//  UpcomingGameCard.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//


import SwiftUI
import Kingfisher

struct UpcomingGameCard: View {
    
    let game: Game
    let playVideo: Bool
    
    @State private var contentSize: CGSize = .zero

    var body: some View {
        ZStack {
            if let videoId = game.videoId, playVideo {
                YoutubeVideoPlayer(videoId: videoId, width: contentSize.width)
            } else {
                gameCover
                gameInfo
            }
        }
        .background(.customBackground)
        .cornerRadius(12)
        .shadow(color: .shadowBlue, radius: 5, x: 5, y: 5)
        .shadow(color: .shadowPurple, radius: 5, x: -5, y: -5)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: {
            contentSize = $0
        }
    }
    
    var gameCover: some View {
        ZStack {
            KFImage.url(game.coverUrl)
                .placeholder {
                    Rectangle()
                        .fill(.customBackground.opacity(0.3))
                }
                .resizable()
                .scaledToFill()
                .clipped()
            
            Image(systemName: "play.fill")
                .resizable()
                .foregroundColor(.textPrimary)
                .frame(width: 24, height: 24)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.surface)
                }
                .opacity(0.8)
        }
        .frame(height: 220)
        .clipped()
    }
    
    var gameInfo: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                Marquee(
                    text: game.name,
                    font: UIFont.preferredFont(from: .headline),
                    gradientEffect: true,
                    gradientColor: .surface.opacity(0.9)
                )
                .foregroundStyle(.textPrimary)
                
                Spacer()
                
                Text(game.releaseDate, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(16)
            .background(.surface.opacity(0.9))
        }
    }
}

#Preview {
    UpcomingGameCard(game: Game.mock(), playVideo: false)
        .frame(height: 200)
        .padding()
}
