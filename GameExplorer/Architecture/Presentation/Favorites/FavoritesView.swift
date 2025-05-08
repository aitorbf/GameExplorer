//
//  FavoritesView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var viewModel: FavoritesViewModel
    
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.tabBarVisibility) private var isTabBarVisible: Binding<Bool>
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack(spacing: .zero) {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(Array(viewModel.favorites.enumerated()), id: \.element.id) { index, game in
                            SearchGameCard(game: game)
                                .padding(.horizontal)
                                .onTapGesture {
                                    coordinator.push(.gameDetail(gameId: game.gameId))
                                }
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.background).ignoresSafeArea())
            .navigationTitle("Favorites")
            .toolbarSetup()
            .task {
                viewModel.loadFavorites()
            }
            .navigationDestination(for: Route.self) { route in
                self.coordinator.build(route: route)
            }
        }
        .onChange(of: coordinator.path) { _, newPath in
            isTabBarVisible.wrappedValue = newPath.isEmpty
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel.mock())
        .environmentObject(Coordinator())
}
