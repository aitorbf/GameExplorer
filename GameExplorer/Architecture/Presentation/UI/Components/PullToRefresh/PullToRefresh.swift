//
//  PullToRefresh.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 13/5/25.
//

import SwiftUI

struct PullToRefresh<Content: View>: View {
    
    var content: Content
    var showsIndicators = false
    
    var onRefresh: () async -> ()
    
    init(
        showsIndicators: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () async -> ()
    ) {
        self.showsIndicators = showsIndicators
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    @StateObject private var scrollDelegate: ScrollViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            VStack(spacing: .zero) {
                // We need it from dynamic island
                Rectangle()
                    .fill(.clear)
                    .frame(height: 100 * scrollDelegate.progress)
                
                ZStack {
                    Spacer().containerRelativeFrame([.horizontal, .vertical])
                    content
                }
            }
            .offset(coordinateSpace: "scroll") { offset in
                scrollDelegate.contentOffset = offset
                
                if !scrollDelegate.isEligible {
                    var progress: CGFloat = offset / 100
                    progress = min(max(progress, 0), 1)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }

                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top) {
            ZStack {
                Capsule()
                    .fill(.black)
                    .zIndex(1000)
            }
            .frame(width: 126, height: 37)
            .offset(y: 11)
            .frame(maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .top) {
                // Shape morphing and metaball animations
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                    context.addFilter(.blur(radius: 10))
                    
                    // Drawing inside new layer
                    context.drawLayer { ctx in
                        for index in [1, 2] {
                            if let resolvedView = context.resolveSymbol(id: index) {
                                // Dynamic island offset -> 11
                                // Circle radius -> 38/2 = 19
                                // Total 11 + 19 = 30
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: 30))
                            }
                        }
                    }
                } symbols: {
                    // Passing capsule and circle for dynamic island pull refresh symbols
                    canvasSymbol()
                        .tag(1)
                        .zIndex(1000)
                    
                    canvasSymbol(isCircle: true)
                        .tag(2)
                        .zIndex(1000)
                }
                .allowsHitTesting(false)
            }
            .overlay(alignment: .top) {
                refreshView()
                    .offset(y: 11) // Dynamic island top offset
                    .zIndex(1000)
            }
            .ignoresSafeArea()
            .zIndex(1000)
        }
        .coordinateSpace(name: "scroll")
        .onAppear {
            scrollDelegate.addGesture()
        }
        .onDisappear {
            scrollDelegate.removeGesture()
        }
        .onChange(of: scrollDelegate.isRefreshing) { _, newValue in
            // Calling async method
            if newValue {
                Task {
                    // 1 second sleep for smooth animation
                    try? await Task.sleep(for: .seconds(1))
                    await onRefresh()
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollDelegate.progress = .zero
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.isEligible = false
                        scrollDelegate.scrollOffset = .zero
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func canvasSymbol(isCircle: Bool = false) -> some View {
        if isCircle {
            // Refresh max size is 150, so to place at it's middle then
            // Offset will be -> 100/2 = 50
            // Circle radius -> 38/2 = 19
            // Total -> 50 + 19 = 70(Round)
            let centerOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 70 ? scrollDelegate.contentOffset : 70) : scrollDelegate.scrollOffset
            let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
            
            // Dynamic scaling
            // 1 - 0.79 = 0.21
            let scaling = ((scrollDelegate.progress / 1) * 0.21)
            
            Circle()
                .fill(.black)
                .frame(width: 47, height: 47)
                .scaleEffect(0.79 + scaling, anchor: .center)
                .offset(y: offset)
        } else {
            Capsule()
                .fill(.black)
                .frame(width: 126, height: 37)
        }
    }
    
    @ViewBuilder
    func refreshView() -> some View {
        // Arrow rotation view when dragging for refresh
        // Applying the same to the refresh view
        let centerOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 70 ? scrollDelegate.contentOffset : 70) : scrollDelegate.scrollOffset
        let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
        
        ZStack {
            Image(systemName: "arrow.down")
                .font(.callout.bold())
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .rotationEffect(.degrees(scrollDelegate.progress * 180))
                .opacity(scrollDelegate.isEligible ? 0 : 1)
            
            ProgressView()
                .tint(.white)
                .frame(width: 38, height: 38)
                .opacity(scrollDelegate.isEligible ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
        .opacity(scrollDelegate.progress)
        .offset(y: offset)
    }
}

class ScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var scrollOffset: CGFloat = .zero
    @Published var contentOffset: CGFloat = .zero
    @Published var progress: CGFloat = .zero
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll()
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            if !isRefreshing {
                if scrollOffset > 100 {
                    isEligible = true
                } else {
                    isEligible = false
                }
            }
        }
    }
}

// Offset modifier
extension View {
    @ViewBuilder
    func offset(
        coordinateSpace: String,
        offset: @escaping (CGFloat) -> ()
    ) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named(coordinateSpace)).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            offset(value)
                        }
                }
            }
    }
}

// Offset preference key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    PullToRefresh {
        VStack {
            Text("Pull to refresh")
                .font(.largeTitle)
        }
    }
    onRefresh: { }
}
