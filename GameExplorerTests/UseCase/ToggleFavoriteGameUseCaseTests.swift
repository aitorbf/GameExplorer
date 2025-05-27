//
//  ToggleFavoriteGameUseCaseTests.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/5/25.
//


import Testing
@testable import GameExplorer

@Suite(.serialized) struct ToggleFavoriteGameUseCaseTests {
    
    private var repository: FavoritesRepository!
    private var useCase: ToggleFavoriteGameUseCase!
    private var game: Game!

    init() async throws {
        self.repository = await FavoritesRepositoryImpl.mock()
        self.useCase = ToggleFavoriteGameUseCaseImpl(repository: repository)
        self.game = Game.mock(id: "toggle-id")
    }

    @Test("Adds game to favorites if not already a favorite")
    func testAddsGameIfNotFavorite() throws {
        #expect(repository.isFavorite(game.id) == false)

        try useCase.execute(game: game)

        #expect(repository.isFavorite(game.id) == true)
    }

    @Test("Removes game from favorites if already a favorite")
    func testRemovesGameIfAlreadyFavorite() throws {
        try repository.add(game)

        #expect(repository.isFavorite(game.id) == true)

        try useCase.execute(game: game)

        #expect(repository.isFavorite(game.id) == false)
    }

    @Test("No error thrown when toggling multiple times")
    func testTogglingMultipleTimes() throws {
        for _ in 0..<5 {
            try useCase.execute(game: game)
        }

        let finalState = repository.isFavorite(game.id)
        #expect(finalState == true)
    }
}
