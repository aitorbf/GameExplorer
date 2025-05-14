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
    // Large title navigation view height
    private let largeNavigationBarHeight: CGFloat = 96
    // Inline title navigation view height
    private let inlineNavigationBarHeight: CGFloat = 44
    
    var body: some View {
        GeometryReader { proxy in
            PullToRefresh {
                VStack(spacing: .zero) {
                    header(safeArea: proxy.safeAreaInsets)
                    
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
                }
                .overlay(alignment: .top) {
                    navigationBar(safeArea: proxy.safeAreaInsets)
                }
            }
            onRefresh: {
                Task {
                    try? await Task.sleep(for: .seconds(1))
                    await viewModel.loadGames()
                }
            }
            .ignoresSafeArea(.container, edges: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customBackground.ignoresSafeArea())
    }
}

private extension UpcomingGamesView {
    
    @ViewBuilder
    func navigationBar(safeArea: EdgeInsets) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("scroll")).minY
            let clampedMinY = min(minY, 0)
            let progress = clampedMinY / inlineNavigationBarHeight
            
            HStack(spacing: .zero) {
                Spacer()
                
                Text("Upcoming Games")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(-progress > 0.75 ? 1 : 0)
                    .padding()
                
                Spacer()
            }
            .frame(width: size.width, height: inlineNavigationBarHeight + safeArea.top, alignment: .bottom)
            .background {
                Color.shadowPurple
                    .opacity(-progress > 0.75 ? 1 : 0)
            }
            .offset(y: -minY)
        }
        .frame(height: inlineNavigationBarHeight + safeArea.top)
    }
    
    @ViewBuilder
    func header(safeArea: EdgeInsets) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("scroll")).minY
            let clampedMinY = min(minY, 0)
            let progress = clampedMinY / largeNavigationBarHeight
            
            let dynamicHeight = max(inlineNavigationBarHeight, largeNavigationBarHeight + clampedMinY) + safeArea.top
            
            Color.shadowPurple
                .frame(width: size.width, height: dynamicHeight + (minY > 0 ? minY : 0))
                .overlay(
                    Text("Upcoming Games")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .opacity(1 + progress)
                        .scaleEffect(1 + progress, anchor: .topTrailing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    , alignment: .bottom
                )
                .offset(y: -minY)
        }
        .frame(height: largeNavigationBarHeight + safeArea.top)
    }
}

#Preview {
    UpcomingGamesView(viewModel: UpcomingGamesViewModel.mock())
}
