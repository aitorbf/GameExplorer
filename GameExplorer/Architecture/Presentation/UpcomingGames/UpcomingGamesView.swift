//
//  UpcomingGamesView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//

import SwiftUI

struct UpcomingGamesView: View {
    
    @StateObject private var viewModel: UpcomingGamesViewModel
    @State private var selectedVideoURL: URL?
    
    init(viewModel: UpcomingGamesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading upcoming games...")
                    .foregroundStyle(Color(.textPrimary))
                    .tint(Color(.textPrimary))
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(Color(.error))
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.games) { game in
                            UpcomingGameCard(game: game, playVideo: selectedVideoURL != nil && game.videoUrl == selectedVideoURL)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedVideoURL = game.videoUrl
                                }
                                .onDisappear {
                                    if game.videoUrl == selectedVideoURL {
                                        selectedVideoURL = nil
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 32)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    UpcomingGamesView(viewModel: UpcomingGamesViewModel.mock())
}
