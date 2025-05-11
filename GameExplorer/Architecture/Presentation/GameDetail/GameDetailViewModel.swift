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
    @Published var errorMessage: String?

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
        errorMessage = nil
        
        do {
            let result = try await fetchGameUseCase.execute(gameId: gameId)
            game = result
            isFavorite = isGameFavoriteUseCase.execute(gameId: gameId)
        } catch {
            errorMessage = "Failed to load game with id \(gameId): \(error.localizedDescription)"
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
    @MainActor static func mock() -> GameDetailViewModel {
        let fetchGameUseCase = FetchGameUseCase(repository: MockGameRepository())
        // TODO: Mock repository
        let modelContext = SwiftDataManager.preview.modelContext
        let isGameFavoriteUseCase = IsGameFavoriteUseCase(repository: FavoritesRepositoryImpl(localDataSource: FavoritesLocalDataSourceImpl(context: modelContext)))
        let toggleFavoriteGameUseCase = ToggleFavoriteGameUseCase(repository: FavoritesRepositoryImpl(localDataSource: FavoritesLocalDataSourceImpl(context: modelContext)))
        return GameDetailViewModel(
            gameId: "1",
            fetchGameUseCase: fetchGameUseCase,
            isGameFavoriteUseCase: isGameFavoriteUseCase,
            toggleFavoriteGameUseCase: toggleFavoriteGameUseCase
        )
    }
}
#endif
