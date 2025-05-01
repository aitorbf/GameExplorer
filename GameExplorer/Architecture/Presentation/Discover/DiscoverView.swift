//
//  DiscoverView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject private var viewModel: DiscoverViewModel

    init(viewModel: DiscoverViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
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
                ScrollView {
                    LazyVStack {
                        ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                            SearchGameCard(game: game)
                                .padding(.horizontal)
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreIfNeeded(currentIndex: index)
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background).ignoresSafeArea())
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .automatic))
    }
}

#Preview {
    DiscoverView(viewModel: DiscoverViewModel.mock())
}
