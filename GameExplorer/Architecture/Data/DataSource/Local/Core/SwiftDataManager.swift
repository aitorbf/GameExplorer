//
//  SwiftDataManager.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 8/5/25.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager {
    
    static let shared = SwiftDataManager()
    static let test = SwiftDataManager(inMemory: true)

    private let modelContainer: ModelContainer
    var modelContext: ModelContext {
        modelContainer.mainContext
    }

    private init(inMemory: Bool = false) {
        let schema = Schema([GameEntity.self])

        let configuration = ModelConfiguration(
            "GameExplorerModel",
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

extension SwiftDataManager {
    
    static func resetTestContext() {
        let context = SwiftDataManager.test.modelContext
        let allGames = try? context.fetch(FetchDescriptor<GameEntity>())
        allGames?.forEach { context.delete($0) }
        try? context.save()
    }
}
