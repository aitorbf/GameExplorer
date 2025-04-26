//
//  TextMarquee.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 25/4/25.
//

import SwiftUI
import Combine

public struct TextMarquee: View {
    public var text: AttributedString
    public var font: Font
    public var leftFade: CGFloat
    public var rightFade: CGFloat
    public var startDelay: Double
    public var alignment: Alignment
    
    @State private var animate = false
    var isCompact = false
    
    public var body: some View {
        let stringSize = text.sizeOfString(usingFont: font)
        
        let animation = Animation
            .linear(duration: Double(stringSize.width) / 25)
            .repeatForever(autoreverses: false)
        
        let nullAnimation = Animation
            .linear(duration: 0)
        
        return ZStack {
            GeometryReader { geo in
                if stringSize.width > geo.size.width {
                    Group {
                        Text(self.text)
                            .lineLimit(1)
                            .font(.init(font))
                            .offset(x: self.animate ? -stringSize.width - geo.size.width / 3 : 0)
                            .animation(self.animate ? animation : nullAnimation, value: self.animate)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + self.startDelay) {
                                    self.animate = geo.size.width < stringSize.width
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        
                        Text(self.text)
                            .lineLimit(1)
                            .font(.init(font))
                            .offset(x: self.animate ? .zero : stringSize.width + geo.size.width / 3)
                            .animation(self.animate ? animation : nullAnimation, value: self.animate)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + self.startDelay) {
                                    self.animate = geo.size.width < stringSize.width
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }
                    .onValueChanged(of: self.text, perform: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.startDelay) {
                            self.animate = geo.size.width < stringSize.width
                        }
                    })
                    .offset(x: leftFade)
                    .mask(
                        HStack(spacing: .zero) {
                            Rectangle()
                                .frame(width: leftFade > .zero ? 2 : .zero)
                                .opacity(.zero)
                            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(.zero), Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                .frame(width: leftFade)
                            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(.zero)]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                                .frame(width: rightFade)
                            Rectangle()
                                .frame(width: rightFade > .zero ? 2 : .zero)
                                .opacity(.zero)
                        }
                    )
                    .frame(width: geo.size.width + leftFade)
                    .offset(x: leftFade * -1)
                } else {
                    Text(self.text)
                        .font(.init(font))
                        .onValueChanged(of: self.text, perform: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.startDelay) {
                                self.animate = geo.size.width < stringSize.width
                            }
                        })
                        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: alignment)
                }
            }
        }
        .frame(height: stringSize.height)
        .frame(maxWidth: isCompact ? stringSize.width : nil)
        .onDisappear { self.animate = false }
    }
    
    public init(
        text: AttributedString,
        font: Font,
        leftFade: CGFloat = .zero,
        rightFade: CGFloat = .zero,
        startDelay: Double = .zero,
        alignment: Alignment = .leading
    ) {
        self.text = text
        self.font = font
        self.leftFade = leftFade
        self.rightFade = rightFade
        self.startDelay = startDelay
        self.alignment = alignment
    }
}

private extension View {
    @ViewBuilder func onValueChanged<T: Equatable>(of value: T, perform onChange: @escaping (T) -> Void) -> some View {
        self.onReceive(Just(value)) { value in
            onChange(value)
        }
    }
}

#Preview {
    TextMarquee(
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        font: .largeTitle,
        leftFade: 20,
        rightFade: 20,
        startDelay: 0.5
    )
    .padding()
}
