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
                                GridGameCard(game: favorite, namespace: animation)
                                    .onTapGesture {
                                        coordinator.push(.gameDetail(gameId: favorite.gameId))
                                    }
                            }
                        )
                        .padding(.horizontal)
                        .gesture(
                            MagnificationGesture(minimumScaleDelta: 0)
                                .onEnded({ value in
                                    let threshold: CGFloat = 0.15
                                    
                                    if value > 1.0 + threshold {
                                        zoomOutGrid()
                                    } else if value < 1.0 - threshold {
                                        zoomInGrid()
                                    }
                                })
                        )
                    } else {
                        VStack(spacing: .zero) {
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    ForEach(Array(viewModel.favorites.enumerated()), id: \.element.id) { index, favorite in
                                        ListGameCard(game: favorite, namespace: animation)
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
                .animation(.easeInOut, value: viewType)
                .animation(.easeInOut, value: gridColumns)
                
                zoomControls
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customBackground)
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
}

private extension FavoritesView {
    
    var zoomControls: some View {
        VStack {
            HStack {
                Spacer()
                VStack( spacing: 16) {
                    Button(action: {
                        zoomOutGrid()
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    
                    Button(action: {
                        zoomInGrid()
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
    
    func zoomInGrid() {
        withAnimation {
            gridColumns = min(gridColumns + 1, maxGridColumns)
        }
    }
    
    func zoomOutGrid() {
        withAnimation {
            gridColumns = max(gridColumns - 1, minGridColumns)
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel.mock())
        .environmentObject(Coordinator())
}
