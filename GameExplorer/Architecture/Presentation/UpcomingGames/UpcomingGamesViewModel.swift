//
//  UpcomingGamesViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import Foundation
import SwiftUI

final class UpcomingGamesViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading: Bool = true
    @Published var showError: Bool = false

    private let fetchUpcomingGamesUseCase: FetchUpcomingGamesUseCase

    init(fetchUpcomingGamesUseCase: FetchUpcomingGamesUseCase) {
        self.fetchUpcomingGamesUseCase = fetchUpcomingGamesUseCase
        
        Task { @MainActor in
            await loadGames()
        }
    }
    
    @MainActor
    func loadGames() async {
        showError = false
        
        do {
            let result = try await fetchUpcomingGamesUseCase.execute()
            games = result
        } catch {
            showError = true
        }
        
        isLoading = false
    }
}

#if DEBUG
extension UpcomingGamesViewModel {
    static func mock() -> UpcomingGamesViewModel {
        let fetchUpcomingGamesUseCase = FetchUpcomingGamesUseCase(repository: MockGameRepository())
        return UpcomingGamesViewModel(fetchUpcomingGamesUseCase: fetchUpcomingGamesUseCase)
    }
}
#endif
