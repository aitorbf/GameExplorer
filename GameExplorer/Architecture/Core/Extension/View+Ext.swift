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
            .toolbarColorScheme(.dark, for: .navigationBar, .tabBar)
            .toolbarBackground(Color(.shadowPurple), for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            .toolbarBackground(.hidden, for: .tabBar)
    }
}
