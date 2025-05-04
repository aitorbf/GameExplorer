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
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.games.isEmpty {
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(Color(.error))
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                                SearchGameCard(game: game)
                                    .padding(.horizontal)
                                    .onAppear {
                                        Task {
                                            await viewModel.loadMoreIfNeeded(currentIndex: index)
                                        }
                                    }
                                    .onTapGesture {
                                        coordinator.push(.gameDetail(game))
                                    }
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.background).ignoresSafeArea())
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Discover")
            .toolbarSetup()
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
    DiscoverView(viewModel: DiscoverViewModel.mock())
        .environmentObject(Coordinator())
}
