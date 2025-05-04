//
//  UpcomingGamesView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//

import SwiftUI

struct UpcomingGamesView: View {
    
    @ObservedObject var viewModel: UpcomingGamesViewModel
    
    @State private var selectedVideoURL: URL?
    
    var body: some View {
        NavigationView {
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
            .background(Color(.background).ignoresSafeArea())
            .navigationTitle("Upcoming Games")
            .toolbarSetup()
        }
    }
}

#Preview {
    UpcomingGamesView(viewModel: UpcomingGamesViewModel.mock())
}
