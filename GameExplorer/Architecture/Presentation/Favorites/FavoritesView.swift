//
//  FavoritesView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

enum FavoritesViewType {
    case grid
    case list
}

struct FavoritesView: View {
    
    @ObservedObject var viewModel: FavoritesViewModel
    
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.tabBarVisibility) private var isTabBarVisible: Binding<Bool>
    @State private var viewType: FavoritesViewType = .grid
    @State private var gridColumns: Int = 2
    @Namespace private var animation
    
    private let maxGridColumns: Int = 5
    private let minGridColumns: Int = 1
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                Group {
                    if viewType == .grid {
                        StaggeredGrid(
                            columns: gridColumns,
                            list: viewModel.favorites,
                            content: { favorite in
                                GridGameCard(game: favorite)
                                    .matchedGeometryEffect(id: favorite.gameId, in: animation)
                                    .onTapGesture {
                                        coordinator.push(.gameDetail(gameId: favorite.gameId))
                                    }
                            }
                        )
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: .zero) {
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    ForEach(Array(viewModel.favorites.enumerated()), id: \.element.id) { index, favorite in
                                        ListGameCard(game: favorite)
                                            .matchedGeometryEffect(id: favorite.gameId, in: animation)
                                            .onTapGesture {
                                                coordinator.push(.gameDetail(gameId: favorite.gameId))
                                            }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 32)
                            }
                        }
                    }
                }
                
                zoomControls
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customBackground)
            .animation(.easeInOut, value: viewType)
            .animation(.easeInOut, value: gridColumns)
            .navigationTitle("Favorites")
            .navigationDestination(for: Screen.self) { screen in
                self.coordinator.build(screen)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewType = viewType == .grid ? .list : .grid
                        }
                    }) {
                        Image(systemName: viewType == .grid ? "rectangle.grid.1x2" : "square.grid.2x2")
                    }
                }
            }
            .toolbarBackground(.shadowPurple, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .task {
                viewModel.loadFavorites()
            }
        }
        .onChange(of: coordinator.path) { _, newPath in
            isTabBarVisible.wrappedValue = newPath.isEmpty
        }
        .onReceive(AppEventCenter.shared.eventPublisher) { event in
            if event == .favoritesUpdated {
                viewModel.loadFavorites()
            }
        }
    }
    
    private var zoomControls: some View {
        VStack {
            HStack {
                Spacer()
                VStack( spacing: 16) {
                    Button(action: {
                        withAnimation {
                            gridColumns = max(gridColumns - 1, minGridColumns)
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    
                    Button(action: {
                        withAnimation {
                            gridColumns = min(gridColumns + 1, maxGridColumns)
                        }
                    }) {
                        Image(systemName: "minus.circle")
                    }
                }
                .foregroundStyle(.textPrimary)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.highlightPurple)
                }
                .padding(.trailing, 16)
                .padding(.top, 16)
                .opacity(viewType == .grid ? 1 : 0)
            }
            Spacer()
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel.mock())
        .environmentObject(Coordinator())
}
