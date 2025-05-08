//
//  GameDetailView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 1/5/25.
//

import SwiftUI
import AVKit

struct GameDetailView: View {
    
    @ObservedObject var viewModel: GameDetailViewModel
    
    @State private var headerHeight: CGFloat = 300
    @State private var scrollOffset: CGFloat = 0
    @State private var showFullDescription: Bool = false
    @Namespace private var topID
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .foregroundStyle(Color(.textPrimary))
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(Color(.error))
                    .padding()
            } else {
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            header
                                .frame(height: max(headerHeight - scrollOffset, 150))
                                .background(Color.black)
                                .overlay(headerOverlay, alignment: .bottomLeading)
                                .clipped()
                                .id(topID)
                            
                            metadataSection
                                .padding(.horizontal)
                            
                            if let videoUrl = viewModel.game?.videoUrl {
                                VideoPlayer(url: videoUrl, width: UIScreen.main.bounds.width - 32)
                                    .cornerRadius(12)
                                    .padding(.top)
                            }
                            
                            descriptionSection
                                .padding(.top)
                                .padding(.horizontal)
                            
                            genresSection
                                .padding(.top)
                            
                            screenshotsSection
                                .padding(.top)
                            
                            footerSection
                                .padding(.vertical)
                                .padding(.horizontal)
                        }
                        .background(GeometryReader {
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                                   value: -$0.frame(in: .named("scroll")).origin.y)
                        })
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scrollOffset = value
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.toggleFavorite()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(Color(.textPrimary))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background).ignoresSafeArea())
    }
    
    private var header: some View {
        AsyncImage(url: viewModel.game?.coverUrl) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
        }
    }
    
    private var headerOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.game?.name ?? "")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(.textPrimary))
                
                Text(viewModel.game?.companies.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color(.textPrimary).opacity(0.8))
            }
                .padding(),
            alignment: .bottomLeading
        )
    }
    
    private var metadataSection: some View {
        HStack(spacing: 4) {
            Text("Release:")
                .font(.subheadline)
                .foregroundColor(Color(.textPrimary))
            
            Text(viewModel.game?.releaseDate ?? Date(), style: .date)
                .font(.subheadline)
                .foregroundStyle(Color(.textSecondary))
            
            Spacer()
            
            Label("\(viewModel.game?.rating ?? "0")", systemImage: "star.fill")
                .font(.subheadline.bold())
                .foregroundStyle(Color(.textPrimary))
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.game?.summary ?? "")
                .font(.body)
                .foregroundColor(Color(.textSecondary))
                .lineLimit(showFullDescription ? nil : 5)
                .multilineTextAlignment(.leading)
                .animation(.easeInOut, value: showFullDescription)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color(.background)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .opacity(showFullDescription ? 0 : 1)
                    .animation(.easeInOut, value: showFullDescription)
                    .allowsHitTesting(false),
                    alignment: .bottom
                )
            
            Button(action: {
                withAnimation {
                    showFullDescription.toggle()
                }
            }) {
                HStack(spacing: 4) {
                    Text(showFullDescription ? "Show less" : "Read more")
                        .font(.caption)
                        .foregroundColor(Color(.textPrimary))

                    ZStack {
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .opacity(showFullDescription ? 0 : 1)
                        Image(systemName: "chevron.up")
                            .font(.caption2)
                            .opacity(showFullDescription ? 1 : 0)
                    }
                    .animation(.easeInOut, value: showFullDescription)
                }
                .padding(.top, 4)
                .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Genres")
                .font(.headline)
                .foregroundColor(Color(.textPrimary))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.game?.genres ?? [], id: \.self) { genre in
                        Text(genre)
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.highlightPurple).opacity(0.5))
                            .clipShape(Capsule())
                            .foregroundColor(Color(.textPrimary))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var screenshotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Screenshots (\(viewModel.game?.screenshotUrls.count ?? 0))")
                .font(.headline)
                .foregroundColor(Color(.textPrimary))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.game?.screenshotUrls ?? [], id: \.self) { url in
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .frame(width: 250, height: 140)
                        .clipped()
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Platforms")
                .font(.headline)
                .foregroundColor(Color(.textPrimary))
            
            Text(viewModel.game?.platforms.joined(separator: ", ") ?? "")
                .foregroundColor(Color(.textSecondary))
            
            Divider()
                .foregroundStyle(Color(.shadowPurple))
            
            Text("Companies Involved")
                .font(.headline)
                .foregroundColor(Color(.textPrimary))
            
            Text(viewModel.game?.companies.joined(separator: ", ") ?? "")
                .foregroundColor(Color(.textSecondary))
        }
    }
}

// MARK: - PreferenceKey for scroll tracking
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    GameDetailView(viewModel: GameDetailViewModel.mock())
}
