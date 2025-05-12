//
//  StaggeredGrid.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/5/25.
//

import SwiftUI

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    
    var columns: Int
    var showsIndicators: Bool
    var spacing: CGFloat
    var list: [T]
    var content: (T) -> Content
    
    init(
        columns: Int,
        showsIndicators: Bool = false,
        spacing: CGFloat = 10,
        list: [T],
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.columns = columns
        self.showsIndicators = showsIndicators
        self.spacing = spacing
        self.list = list
        self.content = content
    }
    
    func setupList() -> [[T]] {
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        var currentIndex: Int = 0
        for item in list {
            gridArray[currentIndex].append(item)
            
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        
        return gridArray
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            HStack(alignment: .top) {
                ForEach(setupList(), id: \.self) { columnItems in
                    LazyVStack(spacing: spacing) {
                        ForEach(columnItems) { item in
                            content(item)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    @Previewable @Namespace var animation
    StaggeredGrid(
        columns: 2,
        list: [Game.mock(), Game.mock(), Game.mock(), Game.mock(), Game.mock(), Game.mock()],
        content: { game in
            GridGameCard(game: game, namespace: animation)
        }
    )
}
