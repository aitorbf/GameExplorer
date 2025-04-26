//
//  IGDBAuthManager.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//


import Foundation

final class IGDBAuthManager {
    static let shared = IGDBAuthManager()

    private let clientID = Bundle.main.infoDictionary?["IGDB_CLIENT_ID"] as? String
    private let clientSecret = Bundle.main.infoDictionary?["IGDB_CLIENT_SECRET"] as? String
    private let grantType = "client_credentials"
    private let tokenURL = "https://id.twitch.tv/oauth2/token"

    @KeychainStorage(key: "IGDBToken", autoInvalidate: true)
    private var token: IGDBToken?

    var currentAccessToken: String? {
        token?.accessToken
    }

    func ensureValidToken() async throws {
        if token == nil {
            try await refreshToken()
        }
    }

    private func refreshToken() async throws {
        var components = URLComponents(string: tokenURL)!
        components.queryItems = [
            .init(name: "client_id", value: clientID),
            .init(name: "client_secret", value: clientSecret),
            .init(name: "grant_type", value: grantType)
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        token = try IGDBToken.from(data: data)
    }
}
