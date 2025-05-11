//
//  GameDetailView.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 1/5/25.
//

import SwiftUI
import Kingfisher

struct GameDetailView: View {
    
    @ObservedObject var viewModel: GameDetailViewModel
    
    @State private var headerHeight: CGFloat = 300
    @State private var showFullDescription: Bool = false
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .foregroundStyle(.textPrimary)
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.error)
                    .padding()
            } else {
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            header
                                .frame(height: headerHeight)
                                .background(Color.black)
                                .overlay(headerOverlay, alignment: .bottomLeading)
                                .clipped()
                            
                            metadataSection
                                .padding(.horizontal)
                            
                            if let videoId = viewModel.game?.videoId {
                                YoutubeVideoPlayer(
                                    videoId: videoId,
                                    width: UIScreen.main.bounds.width - 32
                                )
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
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.toggleFavorite()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customBackground.ignoresSafeArea())
    }
    
    private var header: some View {
        KFImage.url(viewModel.game?.coverUrl)
            .placeholder {
                Rectangle()
                    .fill(.shadowPurple.opacity(0.3))
            }
            .resizable()
            .scaledToFill()
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
                    .foregroundColor(.textPrimary)
                
                Text(viewModel.game?.companies.first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.textPrimary.opacity(0.8))
            }
                .padding(),
            alignment: .bottomLeading
        )
    }
    
    private var metadataSection: some View {
        HStack(spacing: 4) {
            Text("Release:")
                .font(.subheadline)
                .foregroundColor(.textPrimary)
            
            Text(viewModel.game?.releaseDate ?? Date(), style: .date)
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
            
            Spacer()
            
            Label("\(viewModel.game?.rating ?? "0")", systemImage: "star.fill")
                .font(.subheadline.bold())
                .foregroundStyle(.textPrimary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.game?.summary ?? "")
                .font(.body)
                .foregroundColor(.textSecondary)
                .lineLimit(showFullDescription ? nil : 5)
                .multilineTextAlignment(.leading)
                .animation(.easeInOut, value: showFullDescription)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .customBackground]),
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
                        .foregroundColor(.textPrimary)

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
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.game?.genres ?? [], id: \.self) { genre in
                        Text(genre)
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.highlightPurple.opacity(0.5))
                            .clipShape(Capsule())
                            .foregroundColor(.textPrimary)
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
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.game?.screenshotUrls ?? [], id: \.self) { url in
                        KFImage.url(url)
                            .placeholder {
                                Rectangle()
                                    .fill(.shadowPurple.opacity(0.3))
                            }
                            .resizable()
                            .scaledToFill()
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
                .foregroundColor(.textPrimary)
            
            Text(viewModel.game?.platforms.joined(separator: ", ") ?? "")
                .foregroundColor(.textSecondary)
            
            Divider()
                .foregroundStyle(.shadowPurple)
            
            Text("Companies Involved")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(viewModel.game?.companies.joined(separator: ", ") ?? "")
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    GameDetailView(viewModel: GameDetailViewModel.mock())
}
