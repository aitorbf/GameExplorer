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

    init(
        gameId: String,
        fetchGameUseCase: FetchGameUseCase
    ) {
        self.gameId = gameId
        self.fetchGameUseCase = fetchGameUseCase
        
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
        } catch {
            errorMessage = "Failed to load game with id \(gameId): \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
    }
}

#if DEBUG
extension GameDetailViewModel {
    static func mock() -> GameDetailViewModel {
        let fetchGameUseCase = FetchGameUseCase(repository: MockGameRepository())
        return GameDetailViewModel(
            gameId: "1",
            fetchGameUseCase: fetchGameUseCase
        )
    }
}
#endif
