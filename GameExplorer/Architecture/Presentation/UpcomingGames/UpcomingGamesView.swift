//
//  UpcomingGamesView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//

import SwiftUI

struct UpcomingGamesView: View {
    
    @ObservedObject var viewModel: UpcomingGamesViewModel
    
    @State private var selectedGameId: UUID?
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading upcoming games...")
                        .foregroundStyle(Color(.textPrimary))
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(Color(.error))
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 32) {
                            ForEach(viewModel.games) { game in
                                UpcomingGameCard(
                                    game: game,
                                    playVideo: selectedGameId == game.id
                                )
                                .padding(.horizontal)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        selectedGameId = game.id
                                    }
                                }
                                .onDisappear {
                                    if selectedGameId == game.id {
                                        selectedGameId = nil
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
