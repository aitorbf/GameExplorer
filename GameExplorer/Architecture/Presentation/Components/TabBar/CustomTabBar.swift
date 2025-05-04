//
//  CustomTabBar.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 4/5/25.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(TabItem.allCases, id: \.self) { item in
                    Button {
                        selectedTab = item
                    } label: {
                        customTabItem(
                            imageName: item.iconName,
                            title: item.title,
                            isActive: (selectedTab == item)
                        )
                    }
                }
            }
            .padding(6)
        }
        .frame(height: 70)
        .background(Color(.highlightPurple))
        .cornerRadius(35)
        .padding(.horizontal, 26)
    }
    
    private func customTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? Color(.textPrimary) : Color(.shadowPurple))
                .scaledToFit()
                .frame(height: 20)
            if isActive {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isActive ? Color(.textPrimary) : Color(.shadowPurple))
            }
            Spacer()
        }
        .frame(maxWidth: isActive ? .infinity : 60, maxHeight: 60)
        .background(isActive ? Color(.shadowPurple) : .clear)
        .cornerRadius(30)
    }
}

#Preview {
    @Previewable @State var selectedTab: TabItem = .upcoming
    CustomTabBar(selectedTab: $selectedTab)
}
