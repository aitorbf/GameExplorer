//
//  FetchUpcomingGamesUseCaseTests.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 27/5/25.
//

import Testing
@testable import GameExplorer

@Suite struct FetchUpcomingGamesUseCaseTests {
    
    private var useCase: FetchUpcomingGamesUseCase!
    private var repository: MockGameRepository!

    init() {
        repository = MockGameRepository()
        useCase = FetchUpcomingGamesUseCaseImpl(repository: repository)
    }

    @Test("Returns list of upcoming games successfully")
    func testReturnsUpcomingGames() async throws {
        let result = try await useCase.execute()
        #expect(result.count == 10)
    }

    @Test("Throws error when repository fails")
    func testThrowsErrorWhenRepositoryFails() async {
        let errorRepository = ThrowingGameRepository()
        let throwingUseCase = FetchUpcomingGamesUseCaseImpl(repository: errorRepository)
        
        await #expect(throws: ThrowingGameRepository.TestError.self) {
            try await throwingUseCase.execute()
        }
    }
}
