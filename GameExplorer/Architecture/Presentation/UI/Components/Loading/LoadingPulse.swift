//
//  LoadingPulse.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 12/5/25.
//

import SwiftUI

struct LoadingPulse: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.customBackground
            
            Image("Gamepad")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .scaleEffect(animate ? 1.5 : 1.0)
                .animation(
                    .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true),
                    value: animate
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    LoadingPulse()
}
