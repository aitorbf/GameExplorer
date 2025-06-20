//
//  GameDetailViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 1/5/25.
//

import SwiftUI

final class GameDetailViewModel: ObservableObject {
    
    let gameId: String
    
    @Published var game: Game?
    @Published var isFavorite: Bool = false
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false

    private let fetchGameUseCase: FetchGameUseCase
    private let isGameFavoriteUseCase: IsGameFavoriteUseCase
    private let toggleFavoriteGameUseCase: ToggleFavoriteGameUseCase

    init(
        gameId: String,
        fetchGameUseCase: FetchGameUseCase,
        isGameFavoriteUseCase: IsGameFavoriteUseCase,
        toggleFavoriteGameUseCase: ToggleFavoriteGameUseCase
    ) {
        self.gameId = gameId
        self.fetchGameUseCase = fetchGameUseCase
        self.isGameFavoriteUseCase = isGameFavoriteUseCase
        self.toggleFavoriteGameUseCase = toggleFavoriteGameUseCase
        
        Task { @MainActor in
            await loadGame()
        }
    }
    
    @MainActor
    func loadGame() async {
        isLoading = true
        showError = false
        
        do {
            let result = try await fetchGameUseCase.execute(gameId: gameId)
            game = result
            isFavorite = isGameFavoriteUseCase.execute(gameId: gameId)
        } catch {
            showError = true
        }
        
        isLoading = false
    }
    
    func toggleFavorite() {
        guard let game else { return }
        
        do {
            try toggleFavoriteGameUseCase.execute(game: game)
            AppEventCenter.shared.send(.favoritesUpdated)
            isFavorite.toggle()
        } catch {
            print("Failed to toggle favorite game: \(error.localizedDescription)")
        }
    }
}

#if DEBUG
extension GameDetailViewModel {
    
    @MainActor
    static func mock() -> GameDetailViewModel {
        DIContainer.mock.getGameDetailViewModel(gameId: "1")
    }
}
#endif
