//
//  IsGameFavoriteUseCaseTests.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/5/25.
//


import Testing
@testable import GameExplorer

@Suite struct IsGameFavoriteUseCaseTests {
    
    private var repository: FavoritesRepository!
    private var useCase: IsGameFavoriteUseCase!
    private var existingGame: Game!

    init() async throws {
        let preloaded = GameEntity.mockList()
        self.repository = await FavoritesRepositoryImpl.mock(preloadedGames: preloaded)
        self.useCase = IsGameFavoriteUseCaseImpl(repository: repository)
        self.existingGame = GameMapper.map(preloaded.first!)
    }

    @Test("Returns true for a game that is in favorites")
    func testReturnsTrueIfGameIsFavorite() {
        let result = useCase.execute(gameId: existingGame.id)
        #expect(result == true)
    }

    @Test("Returns false for a game not in favorites")
    func testReturnsFalseIfGameNotFavorite() {
        let result = useCase.execute(gameId: "nonexistent")
        #expect(result == false)
    }
}
