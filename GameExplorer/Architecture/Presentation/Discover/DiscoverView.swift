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
                    ProgressView("Searching...")
                        .foregroundStyle(.textPrimary)
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.error)
                        .padding()
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
                                        coordinator.push(.gameDetail(gameId: game.gameId))
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
