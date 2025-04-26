//
//  FavoriteView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        ZStack {
            Text("Favorite Games")
                .foregroundStyle(Color(.textPrimary))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FavoriteView()
}
