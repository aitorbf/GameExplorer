//
//  FetchGameUseCaseTests.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/5/25.
//


import Testing
@testable import GameExplorer

@Suite struct FetchGameUseCaseTests {
    
    private var repository: GameRepository!
    private var useCase: FetchGameUseCase!

    init() {
        repository = MockGameRepository()
        useCase = FetchGameUseCaseImpl(repository: repository)
    }

    @Test("Returns a game for a valid ID")
    func testReturnsGameForValidId() async throws {
        let result = try await useCase.execute(gameId: "1")
        #expect(result != nil)
        #expect(result?.id == "1")
        #expect(result?.name == "Game 1")
    }

    @Test("Returns nil for an unknown ID")
    func testReturnsNilForUnknownId() async throws {
        let result = try await useCase.execute(gameId: "nonexistent")
        #expect(result == nil)
    }

    @Test("Maps GameEntity to Game correctly")
    func testMappingToDomainModel() async throws {
        let result = try await useCase.execute(gameId: "2")!
        #expect(result.name == "Game 2")
        #expect(result.genres.contains("RPG"))
        #expect(result.companies.count > 0)
    }

    @Test("Throws error when repository fails")
    func testThrowsErrorWhenRepositoryFails() async {
        let errorRepo = ThrowingGameRepository()
        let throwingUseCase = FetchGameUseCaseImpl(repository: errorRepo)

        await #expect(throws: ThrowingGameRepository.TestError.self) {
            try await throwingUseCase.execute(gameId: "any")
        }
    }
}
