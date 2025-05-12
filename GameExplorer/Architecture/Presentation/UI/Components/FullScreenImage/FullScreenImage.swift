//
//  FullScreenImage.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 11/5/25.
//

import SwiftUI
import Kingfisher

struct FullScreenImage: View {
    
    @Binding var url: URL?
    @Binding var isPresented: Bool
    
    @State private var screenWidth = 0.0
    @State private var scale = 1.0
    @State private var lastScale = 0.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                KFImage
                    .url(url)
                    .placeholder {
                        Rectangle()
                            .fill(.shadowPurple.opacity(0.3))
                    }
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture(minimumScaleDelta: 0)
                            .onChanged({ value in
                                withAnimation(.interactiveSpring()) {
                                    scale = handleScaleChange(value)
                                }
                            })
                            .onEnded({ _ in
                                lastScale = scale
                            })
                            .simultaneously(
                                with: DragGesture(minimumDistance: 0)
                                    .onChanged({ value in
                                        withAnimation(.interactiveSpring()) {
                                            offset = handleOffsetChange(value.translation)
                                        }
                                    })
                                    .onEnded({ _ in
                                        lastOffset = offset
                                    })
                                
                            )
                    )
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                url = nil
                                isPresented = false
                                scale = 1.0
                                offset = .zero
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                screenWidth = geometry.size.width
            }
        }
    }
}

private extension FullScreenImage {
    
    private func handleScaleChange(_ zoom: CGFloat) -> CGFloat {
        lastScale + zoom - (lastScale == 0 ? 0 : 1)
    }
    
    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        
        newOffset.width = offset.width + lastOffset.width
        newOffset.height = offset.height + lastOffset.height
        
        return newOffset
    }
}
