//
//  EmptyState.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 12/5/25.
//


import SwiftUI

struct EmptyState: View {
    let title: String
    let message: String
    let iconName: String?

    var body: some View {
        VStack(spacing: .zero) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, 32)
            }

            Text(title)
                .font(.title2.bold())
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.customBackground
                .ignoresSafeArea()
        )
    }
}
