//
//  UpcomingGamesViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import Foundation
import SwiftUI

@MainActor
final class UpcomingGamesViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchUpcomingGamesUseCase: FetchUpcomingGamesUseCase

    init(fetchUpcomingGamesUseCase: FetchUpcomingGamesUseCase) {
        self.fetchUpcomingGamesUseCase = fetchUpcomingGamesUseCase
    }

    func loadGames() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await fetchUpcomingGamesUseCase.execute()
            games = result
        } catch {
            errorMessage = "Failed to load games: \(error.localizedDescription)"
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
