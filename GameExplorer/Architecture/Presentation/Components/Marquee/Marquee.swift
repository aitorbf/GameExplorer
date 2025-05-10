//
//  Marquee.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 10/5/25.
//

import SwiftUI

struct Marquee: View {
    
    @State var text: String
    var font: UIFont
    // Animation speed
    var animationSpeed: Double = 0.02
    var delayTime: Double = 0.5
    // Gradient effect
    var gradientEffect: Bool = false
    var gradientColor: Color = .white
    
    // Stored text size
    @State private var storedSize: CGSize = .zero
    // Animation offset
    @State private var offset: CGFloat = .zero
    @State private var shouldAnimate: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                Text(text)
                    .font(Font(font))
                    .offset(x: offset)
                    .padding(.horizontal, gradientEffect && shouldAnimate ? 15 : .zero)
                    .background(
                        Color.clear
                            .onAppear {
                                let availableWidth = geometry.size.width
                                shouldAnimate = textSize().width > availableWidth
                                animateText()
                            }
                    )
                
            }
            // Opacity effect
            .overlay {
                if gradientEffect && shouldAnimate {
                    HStack {
                        LinearGradient(
                            colors: [gradientColor, gradientColor.opacity(0.7), gradientColor.opacity(0.5), gradientColor.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 20)
                        
                        Spacer()
                        
                        LinearGradient(
                            colors: [gradientColor, gradientColor.opacity(0.7), gradientColor.opacity(0.5), gradientColor.opacity(0.3)].reversed(),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 20)
                    }
                } else {
                    EmptyView()
                }
            }
            // Disabling manual scrolling
            .disabled(true)
        }
        .frame(height: textSize().height)
    }
}

private extension Marquee {
    
    // Fetching text size for offset animation
    func textSize() -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size
    }
    
    // Activate marquee animation
    func animateText() {
        guard shouldAnimate else { return }
        
        let baseText = text
        
        // Continous text animation
        // Adding spacing for continous text
        text.append(String(repeating: " ", count: 15))
        
        // Stopping animation exactly before the next text
        storedSize = textSize()
        text.append(baseText)
        
        // Calculating total secs based in text width
        let timing = animationSpeed * storedSize.width
        
        // Delaying first animation
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            withAnimation(.linear(duration: timing)) {
                offset = -storedSize.width
            }
        }
        
        // Repeating marquee effect with the help of timer
        Timer.scheduledTimer(withTimeInterval: timing + delayTime, repeats: true) { _ in
            // Resetting offset to 0
            // It looks like is looping
            offset = .zero
            withAnimation(.linear(duration: timing)) {
                offset = -storedSize.width
            }
        }
    }
}

#Preview {
    VStack {
        Marquee(
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            font: UIFont.preferredFont(from: .largeTitle),
            gradientEffect: true
        )
        
        Marquee(
            text: "Short text",
            font: UIFont.preferredFont(from: .largeTitle),
            gradientEffect: true
        )
    }
}
