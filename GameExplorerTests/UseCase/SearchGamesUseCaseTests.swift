//
//  SearchGamesUseCaseTests.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 26/5/25.
//

import Testing
@testable import GameExplorer

@Suite struct SearchGamesUseCaseTests {
    
    private var useCase: SearchGamesUseCase!
    private var repository: MockGameRepository!
    
    init() {
        repository = MockGameRepository()
        useCase = SearchGamesUseCaseImpl(repository: repository)
    }
    
    @Test("Returns games matching a valid query")
    func testSearchGamesWithValidQuery() async throws {
        let result = try await useCase.execute(searchQuery: "Game 1", offset: 0, limit: 10)
        #expect(result.count > 0)
        #expect(result.contains(where: { $0.name.contains("Game 1") }))
    }
    
    @Test("Returns all games when query is empty")
    func testReturnsAllGamesWhenQueryIsEmpty() async throws {
        let result = try await useCase.execute(searchQuery: "", offset: 0, limit: 10)
        #expect(result.count == 10)
    }
    
    @Test("Pagination returns correct range")
    func testPaginationReturnsCorrectRange() async throws {
        let result = try await useCase.execute(searchQuery: "", offset: 2, limit: 3)
        #expect(result.count == 3)
        #expect(result.first?.id == "3")
    }
    
    @Test("Returns empty list for out-of-bounds offset")
    func testOutOfBoundsOffsetReturnsEmptyList() async throws {
        let result = try await useCase.execute(searchQuery: "", offset: 100, limit: 10)
        #expect(result.isEmpty)
    }
    
    @Test("Search is case insensitive")
    func testSearchIsCaseInsensitive() async throws {
        let result = try await useCase.execute(searchQuery: "gAmE 2", offset: 0, limit: 10)
        #expect(result.count == 1)
        #expect(result.first?.name == "Game 2")
    }
    
    @Test("Limit greater than result size returns all")
    func testLimitGreaterThanResultSizeReturnsAll() async throws {
        let result = try await useCase.execute(searchQuery: "Game 3", offset: 0, limit: 100)
        #expect(result.count == 1)
    }
    
    @Test("Limit 0 returns empty list")
    func testReturnsEmptyListWhenLimitIsZero() async throws {
        let result = try await useCase.execute(searchQuery: "Game", offset: 0, limit: 0)
        #expect(result.isEmpty)
    }
    
    @Test("Throws error when repository fails")
    func testThrowsErrorWhenRepositoryFails() async {
        let errorRepository = ThrowingGameRepository()
        let throwingUseCase = SearchGamesUseCaseImpl(repository: errorRepository)
        
        await #expect(throws: ThrowingGameRepository.TestError.self) {
            try await throwingUseCase.execute(searchQuery: "any", offset: 0, limit: 10)
        }
    }
}
