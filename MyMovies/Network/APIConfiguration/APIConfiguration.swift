//
//  APIConfiguration.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

// MARK: - APIConfigModels
// User network country
enum Country: String {
    case russia = "RU"
    case belarus = "BY"
    case unitedKingdom = "GB"
    case networkError = "networkError"
    case defaultCountry = "default"

    // Get Info.plist config property name for country
    var configPlistName: String {
        switch self {
        case .russia, .belarus, .networkError:
            return "RU_MovieAPI"
        default:
            return "EN_MovieAPI"
        }
    }

    var language: String {
        switch self {
        case .russia, .belarus, .networkError:
            return "RU"
        default:
            return "EN"
        }
    }
}

// API provider
enum Provider: String {
    case tmdb
    case kinopoisk
}

// MARK: - Endpoints
enum Endpoint: String {
    case popularMovies
    case trendingMovies
    // Get the list of official genres for movies
    case genres
}

// MARK: - APIConfiguration
struct APIConfiguration: APIConfigurationProtocol {
    private let baseURL: URL
    private let authHeader: [String: String]
    private let endpoints: [String: String]
    private let provider: Provider
    private let language: String

    init(baseURL: URL, authHeader: [String: String], endpoints: [String: String], provider: Provider, language: String) {
        self.baseURL = baseURL
        self.authHeader = authHeader
        self.endpoints = endpoints
        self.provider = provider
        self.language = language
    }

    // MARK: - Public
    func url(for endpoint: Endpoint) -> URL? {
        guard let path = getPath(for: endpoint) else {
            return nil
        }

        return URL(string: "\(baseURL.absoluteString)\(path)")
    }

    func responseType(for endpoint: Endpoint) -> Codable.Type? {
        return getResponseType(for: endpoint, and: provider)
    }

    func authorizationHeader() -> [String: String] {
        return authHeader
    }

    // MARK: - Private
    private func getResponseType(for endpoint: Endpoint, and provider: Provider) -> Codable.Type? {
        switch (provider, endpoint) {
        case (.tmdb, .genres):
            return TMDBGenresResponse.self
        case (.kinopoisk, .genres):
            return [Genre].self
        default:
            return nil
        }
    }

    private func getPath(for endpoint: Endpoint) -> String? {
        return endpoints[endpoint.rawValue]
    }
}
