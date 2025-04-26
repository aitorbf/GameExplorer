//
//  IGDBToken.swift
//  GameExplorer
//
//  Created by Aitor Baragaño Fernández on 22/4/25.
//


import Foundation

struct IGDBToken: Codable, Expirable {
    let accessToken: String?
    let expiresIn: TimeInterval?
    let tokenType: String?
    var createdAt: Date?

    var expirationDate: Date {
        return createdAt?.addingTimeInterval(expiresIn ?? .zero) ?? Date()
    }

    var isExpired: Bool {
        return Date() >= expirationDate
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case createdAt = "createdAt"
    }

    static func from(data: Data) throws -> Self {
        var token = try JSONDecoder().decode(IGDBToken.self, from: data)
        token.createdAt = Date()
        return token
    }
}
