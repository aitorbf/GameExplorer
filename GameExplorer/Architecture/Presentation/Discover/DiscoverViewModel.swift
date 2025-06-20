//
//  DiscoverViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/4/25.
//

import Foundation
import Combine
import SwiftUI

final class DiscoverViewModel: ObservableObject {
    
    @Published var searchQuery: String = ""
    @Published var games: [Game] = []
    @Published var isLoading: Bool = true
    @Published var showError: Bool = false
    
    private let searchGamesUseCase: SearchGamesUseCase
    private let limit: Int = 50
    
    private var offset: Int = 0
    private var isFetching = false
    private var canFetchMore = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init(searchGamesUseCase: SearchGamesUseCase) {
        self.searchGamesUseCase = searchGamesUseCase
        observeQueryChanges()
        
        Task { @MainActor in
            await search()
        }
    }
    
    @MainActor
    func search(reset: Bool = true) async {
        if reset {
            resetState()
        }
        
        guard !isFetching, canFetchMore else { return }
        
        isLoading = true
        isFetching = true
        showError = false
        
        do {
            let newGames = try await searchGamesUseCase.execute(searchQuery: searchQuery, offset: offset, limit: limit)
            games.append(contentsOf: newGames)
            canFetchMore = newGames.count == limit
            offset += newGames.count
            isLoading = false
            isFetching = false
        } catch {
            showError = true
            isLoading = false
            isFetching = false
        }
    }
    
    func loadMoreIfNeeded(currentIndex: Int) async {
        guard canFetchMore, !isFetching else { return }
        
        let thresholdIndex = games.count - (limit / 2)
        if currentIndex >= thresholdIndex {
            await search(reset: false)
        }
    }
}

private extension DiscoverViewModel {
    
    private func observeQueryChanges() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                
                Task {
                    await self.search(reset: true)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func resetState() {
        games = []
        offset = 0
        isLoading = false
        isFetching = false
        canFetchMore = true
        showError = false
    }
}

#if DEBUG
extension DiscoverViewModel {
    
    @MainActor
    static func mock() -> DiscoverViewModel {
        DIContainer.mock.getDiscoverViewModel()
    }
}
#endif
