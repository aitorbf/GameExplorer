//
//  ErrorView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 12/5/25.
//

import SwiftUI

struct ErrorView: View {
    
    let title: String
    let message: String
    let iconName: String?
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            if let icon = iconName {
                Image(systemName: icon)
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
                .padding(.bottom, 8)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 16)

            Button(action: retryAction) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.customBackground
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ErrorView(
        title: "Oops!",
        message: "Something went wrong. Please try again.",
        iconName: "exclamationmark.triangle",
        retryAction: {}
    )
}
