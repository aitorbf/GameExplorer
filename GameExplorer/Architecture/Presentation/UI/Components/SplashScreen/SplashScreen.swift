//
//  SplashScreen.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 12/5/25.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var splashAnimation: Bool = false
    
    var body: some View {
        ZStack {
            Color.shadowPurple
            
            Image(.gamepad)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .scaleEffect(splashAnimation ? 150 : 1)
        }
        .opacity(splashAnimation ? 0 : 1)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.splashAnimation.toggle()
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
