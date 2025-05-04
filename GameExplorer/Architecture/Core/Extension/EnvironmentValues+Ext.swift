//
//  EnvironmentValues+Ext.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 4/5/25.
//

import SwiftUI

struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(true)
}

extension EnvironmentValues {
    var tabBarVisibility: Binding<Bool> {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}
