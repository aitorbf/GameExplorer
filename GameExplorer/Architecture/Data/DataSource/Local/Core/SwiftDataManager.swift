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
    static let preview = SwiftDataManager(inMemory: true)

    let modelContainer: ModelContainer
    var modelContext: ModelContext { modelContainer.mainContext }

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
