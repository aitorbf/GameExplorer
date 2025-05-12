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
                    LoadingPulse()
                } else if viewModel.games.isEmpty {
                    EmptyState(
                        title: "No Upcoming Games",
                        message: "We couldn't find any upcoming releases at the moment. Check back later!",
                        iconName: "calendar.badge.exclamationmark"
                    )
                } else if viewModel.showError {
                    ErrorView(
                        title: "Oops!",
                        message: "Something went wrong. Please try again.",
                        iconName: "exclamationmark.triangle",
                        retryAction: {
                            Task {
                                await viewModel.loadGames()
                            }
                        }
                    )
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
            .background(Color.customBackground.ignoresSafeArea())
            .navigationTitle("Upcoming Games")
            .toolbarBackground(.shadowPurple, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    UpcomingGamesView(viewModel: UpcomingGamesViewModel.mock())
}
