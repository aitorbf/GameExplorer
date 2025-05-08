//
//  FavoritesViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published var favorites: [Game] = []
    
    private let getFavoriteGamesUseCase: GetFavoriteGamesUseCase

    init(getFavoriteGamesUseCase: GetFavoriteGamesUseCase) {
        self.getFavoriteGamesUseCase = getFavoriteGamesUseCase
    }

    func loadFavorites() {
        favorites = getFavoriteGamesUseCase.execute()
    }
}

#if DEBUG
extension FavoritesViewModel {
    @MainActor static func mock() -> FavoritesViewModel {
        // TODO: Mock repository
        let modelContext = SwiftDataManager.preview.modelContext
        let getFavoriteGamesUseCase = GetFavoriteGamesUseCase(repository: FavoritesRepositoryImpl(localDataSource: FavoritesLocalDataSourceImpl(context: modelContext)))
        return FavoritesViewModel(getFavoriteGamesUseCase: getFavoriteGamesUseCase)
    }
}
#endif
