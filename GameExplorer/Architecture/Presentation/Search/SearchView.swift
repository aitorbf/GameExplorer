//
//  SearchView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 23/4/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            Text("Search Games")
                .foregroundStyle(Color(.textPrimary))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchView()
}
