//
//  GameDetailViewModel.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 1/5/25.
//

import SwiftUI

final class GameDetailViewModel: ObservableObject {
    let game: Game

    init(game: Game) {
        self.game = game
    }
}
