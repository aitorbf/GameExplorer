//
//  GameDetailView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 1/5/25.
//

import SwiftUI

struct GameDetailView: View {
    
    @ObservedObject var viewModel: GameDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                if let imageUrl = viewModel.game.coverUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(viewModel.game.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color(.textPrimary))

                HStack {
                    Text("Release Date: ")
                        .font(.subheadline)
                        .foregroundStyle(Color(.textSecondary))
                    Text(viewModel.game.releaseDate, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(Color(.textSecondary))
                }

                if let videoUrl = viewModel.game.videoUrl {
                    VideoPlayer(url: videoUrl, width: UIScreen.main.bounds.width - 32)
                        
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background).ignoresSafeArea())
        .toolbarSetup()
    }
}

#Preview {
    GameDetailView(viewModel: GameDetailViewModel(game: Game.mock()))
}
