//
//  VideoPlayer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayer: View {
    let url: URL
    let width: CGFloat
    
    private let aspectRatio: CGFloat = 9 / 16 // 16:9 Youtube aspect ratio

    var body: some View {
        ZStack {
            Color(.surface)
            YouTubePlayerView(getYoutubePlayer(url: url)) { state in
                switch state {
                case .idle:
                    ProgressView().foregroundStyle(Color.textSecondary)
                default:
                    EmptyView()
                }
            }
        }
        .frame(width: width, height: width * aspectRatio)
    }
    
    private func getYoutubePlayer(url: URL) -> YouTubePlayer {
        let player: YouTubePlayer = YouTubePlayer(url: url)
        player.parameters.autoPlay = true
        return player
    }
}

#Preview {
    VideoPlayer(url: Game.mock().videoUrl!, width: UIScreen.main.bounds.width - 32)
        .padding(.horizontal, 16)
}
