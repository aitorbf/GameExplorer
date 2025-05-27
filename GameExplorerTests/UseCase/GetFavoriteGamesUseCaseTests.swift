//
//  GetFavoriteGamesUseCaseTests.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/5/25.
//

import Testing
@testable import GameExplorer

@Suite struct GetFavoriteGamesUseCaseTests {
    
    private var repository: FavoritesRepository!
    private var useCase: GetFavoriteGamesUseCase!

    init() async throws {
        let mockGames = GameEntity.mockList()
        repository = await FavoritesRepositoryImpl.mock(preloadedGames: mockGames)
        useCase = GetFavoriteGamesUseCaseImpl(repository: repository)
    }

    @Test("Returns all favorite games")
    func testReturnsFavoriteGames() {
        let result = useCase.execute()
        #expect(result.count == GameEntity.mockList().count)
    }

    @Test("Returns empty list when no favorites exist")
    func testReturnsEmptyWhenNoFavorites() async throws {
        let emptyRepository = await FavoritesRepositoryImpl.mock(preloadedGames: [])
        let emptyUseCase = GetFavoriteGamesUseCaseImpl(repository: emptyRepository)

        let result = emptyUseCase.execute()
        #expect(result.isEmpty)
    }

    @Test("Maps GameEntity to Game correctly")
    func testMappingEntityToDomainModel() throws {
        let games = useCase.execute()
        
        try #require(!games.isEmpty, "Expected at least one game to be returned")
        
        let game = games.first!
        
        #expect(type(of: game) == Game.self)
        #expect(!game.id.isEmpty)
    }
}
