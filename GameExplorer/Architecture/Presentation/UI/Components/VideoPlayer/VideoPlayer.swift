//
//  VideoPlayer.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI
import YouTubePlayerKit

struct YoutubeVideoPlayer: View {
    let videoId: String
    let width: CGFloat
    
    private let aspectRatio: CGFloat = 9 / 16 // 16:9 Youtube aspect ratio
    
    var body: some View {
        ZStack {
            Color.surface
            YouTubePlayerView(
                YouTubePlayer(
                    source: .video(id: videoId),
                    parameters: .init(autoPlay: true)
                )
            ) { state in
                switch state {
                case .idle:
                    ProgressView()
                        .foregroundStyle(Color.textPrimary)
                default:
                    EmptyView()
                }
            }
        }
        .frame(width: width, height: width * aspectRatio)
    }
}

#Preview {
    YoutubeVideoPlayer(
        videoId: Game.mock().videoId ?? "",
        width: UIScreen.main.bounds.width - 32
    )
    .padding(.horizontal, 16)
}
