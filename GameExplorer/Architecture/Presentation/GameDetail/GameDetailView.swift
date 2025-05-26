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
    
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showFullDescription: Bool = false
    @State private var selectedScreenshotURL: URL?
    @State private var isShowingFullScreenImage = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    VStack(spacing: 16) {
                        header(
                            safeArea: proxy.safeAreaInsets,
                            size: proxy.size
                        )
                        
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
                    .opacity(viewModel.isLoading ? 0 : 1)
                    
                    ErrorView(
                        title: "Oops!",
                        message: "Something went wrong. Please try again.",
                        iconName: "exclamationmark.triangle",
                        retryAction: {
                            Task {
                                await viewModel.loadGame()
                            }
                        }
                    )
                    .opacity(viewModel.showError ? 1 : 0)
                    
                    LoadingPulse()
                        .opacity(viewModel.isLoading ? 1 : 0)
                }
                .overlay(alignment: .top) {
                    navigationBar(
                        safeArea: proxy.safeAreaInsets,
                        size: proxy.size
                    )
                }
                .onChange(of: selectedScreenshotURL) { oldValue, newValue in
                    if newValue != nil {
                        isShowingFullScreenImage = true
                    }
                }
                .fullScreenCover(isPresented: $isShowingFullScreenImage) {
                    FullScreenImage(url: $selectedScreenshotURL, isPresented: $isShowingFullScreenImage)
                }
            }
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea(.container, edges: .top)
            
            // TODO: Check error state
        }
        .animation(.easeInOut, value: viewModel.isLoading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customBackground)
        .toolbar(.hidden)
    }
}

private extension GameDetailView {
    
    @ViewBuilder
    func navigationBar(safeArea: EdgeInsets, size: CGSize) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            HStack(spacing: 15) {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(4)
                }
                
                Spacer()
                
                Text(viewModel.game?.name ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                    .offset(y: -progress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -progress > 0.75)
                
                Spacer()
                
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                .opacity(viewModel.isLoading ? 0 : 1)
            }
            .padding(.top, safeArea.top + 10)
            .padding([.horizontal, .bottom], 15)
            .background {
                Color.shadowPurple
                    .opacity(-progress > 0.75 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.25), value: -progress > 0.75)
            }
            .offset(y: -minY)
        }
        .frame(height: 35)
    }
    
    @ViewBuilder
    func header(safeArea: EdgeInsets, size: CGSize) -> some View {
        let height = size.height * 0.45
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("scroll")).minY
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            
            KFImage.url(viewModel.game?.coverUrl)
                .placeholder {
                    Rectangle()
                        .fill(.shadowPurple.opacity(0.3))
                }
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .clipped()
                .overlay {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(
                                .linearGradient(
                                    colors: [
                                        .customBackground.opacity(0 - progress),
                                        .customBackground.opacity(0.1 - progress),
                                        .customBackground.opacity(0.3 - progress),
                                        .customBackground.opacity(0.5 - progress),
                                        .customBackground.opacity(0.8 - progress),
                                        .customBackground.opacity(1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.game?.name ?? "")
                                .font(.largeTitle.bold())
                                .foregroundColor(.textPrimary)
                            
                            Text(viewModel.game?.companies.first ?? "")
                                .font(.subheadline)
                                .foregroundColor(.textPrimary.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding()
                        .offset(y: minY < 0 ? minY : 0)
                    }
                }
                .offset(y: -minY)
        }
        .frame(height: height + safeArea.top)
    }
    
    var metadataSection: some View {
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
    
    var descriptionSection: some View {
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
            
            Button {
                withAnimation {
                    showFullDescription.toggle()
                }
            } label: {
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
    
    var genresSection: some View {
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
    
    var screenshotsSection: some View {
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
                            .onTapGesture {
                                selectedScreenshotURL = url
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    var footerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Platforms")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(viewModel.game?.platforms.joined(separator: ", ") ?? "")
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .foregroundStyle(.shadowPurple)
            
            Text("Companies Involved")
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(viewModel.game?.companies.joined(separator: ", ") ?? "")
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    GameDetailView(viewModel: GameDetailViewModel.mock())
}
