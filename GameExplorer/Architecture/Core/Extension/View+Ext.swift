//
//  View+Ext.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 26/4/25.
//

import SwiftUI

extension View {
    func toolbarSetup() -> some View {
        self
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color(.shadowPurple), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.hidden, for: .tabBar)
    }
}
