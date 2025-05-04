//
//  FavoritesView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

struct FavoritesView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("Favorite Games")
                    .foregroundStyle(Color(.textPrimary))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.background).ignoresSafeArea())
            .navigationTitle("Favorites")
            .toolbarSetup()
        }
    }
}

#Preview {
    FavoritesView()
}
