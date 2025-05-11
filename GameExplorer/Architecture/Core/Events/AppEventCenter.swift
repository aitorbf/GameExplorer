//
//  AppEventCenter.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 11/5/25.
//

import Combine

enum AppEvent: Hashable {
    case favoritesUpdated
}

final class AppEventCenter {
    
    static let shared = AppEventCenter()

    let eventPublisher = PassthroughSubject<AppEvent, Never>()

    private init() {}
    
    func send(_ event: AppEvent) {
        eventPublisher.send(event)
    }
}
