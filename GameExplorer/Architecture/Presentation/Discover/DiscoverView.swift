//
//  DiscoverView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

struct DiscoverView: View {
    
    @ObservedObject var viewModel: DiscoverViewModel
    
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.tabBarVisibility) private var isTabBarVisible: Binding<Bool>
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack(spacing: .zero) {
                if viewModel.isLoading && viewModel.games.isEmpty {
                    LoadingPulse()
                } else if viewModel.searchQuery.isEmpty && viewModel.games.isEmpty {
                    EmptyState(
                        title: "Search for Games",
                        message: "Start typing to discover new titles",
                        iconName: "gamecontroller"
                    )
                } else if !viewModel.searchQuery.isEmpty && viewModel.games.isEmpty {
                    EmptyState(
                        title: "No Results",
                        message: "We couldn't find any games matching \"\(viewModel.searchQuery)\". Try a different keyword",
                        iconName: "magnifyingglass"
                    )
                } else if viewModel.showError {
                    ErrorView(
                        title: "Oops!",
                        message: "Something went wrong. Please try again.",
                        iconName: "exclamationmark.triangle",
                        retryAction: {
                            Task {
                                await viewModel.search()
                            }
                        }
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                                ListGameCard(game: game)
                                    .padding(.horizontal)
                                    .onAppear {
                                        Task {
                                            await viewModel.loadMoreIfNeeded(currentIndex: index)
                                        }
                                    }
                                    .onTapGesture {
                                        coordinator.push(.gameDetail(gameId: game.id))
                                    }
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customBackground.ignoresSafeArea())
            .navigationTitle("Discover")
            .navigationDestination(for: Screen.self) { screen in
                self.coordinator.build(screen)
            }
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .toolbarBackground(.shadowPurple, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onChange(of: coordinator.path) { _, newPath in
            isTabBarVisible.wrappedValue = newPath.isEmpty
        }
    }
}

#Preview {
    DiscoverView(viewModel: DiscoverViewModel.mock())
        .environmentObject(Coordinator())
}
