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
enum Endpoint {
    // Get a list of movies that are being released soon.
    case upcomingMovies
    // Get the list of official genres for movies
    case genres
    // Get a list of movies ordered by popularity
    case popularMovies
    // Get the movie details by ID
    case movieDetails(id: Int)

    var rawValue: String {
        switch self {
        case .upcomingMovies:
            return "upcomingMovies"
        case .genres:
            return "genres"
        case .popularMovies:
            return "popularMovies"
        case .movieDetails:
            return "movieDetails"
        }
    }

    var pathParameters: String {
        switch self {
        case .movieDetails(let id):
            return "\(id)"
        default:
            return ""
        }
    }
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
    func isActive(endpoint: Endpoint) -> Bool {
        return isActive(endpoint: endpoint, for: provider)
    }

    func url(for endpoint: Endpoint) -> URL? {
        let path = getPath(for: endpoint)

        return URL(string: "\(baseURL.absoluteString)\(path)")
    }

    func responseType(for endpoint: Endpoint) -> Codable.Type? {
        return getResponseType(for: endpoint, and: provider)
    }

    func authorizationHeader() -> [String: String] {
        return authHeader
    }

    // MARK: - Private
    private func isActive(endpoint: Endpoint, for provider: Provider) -> Bool {
        switch (provider, endpoint) {
        case (.kinopoisk, .movieDetails):
            return false
        default:
            return true
        }
    }

    private func getResponseType(for endpoint: Endpoint, and provider: Provider) -> Codable.Type? {
        switch (provider, endpoint) {
        case (.tmdb, .genres):
            return TMDBGenrePagedResponse.self
        case (.kinopoisk, .genres):
            return [KinopoiskMovieResponse.Genre].self
        case (.tmdb, .upcomingMovies), (.tmdb, .popularMovies):
            return TMDBMoviesPagedResponse.self
        case (.kinopoisk, .upcomingMovies), (.kinopoisk, .popularMovies):
            return KinopoiskMoviesPagedResponse.self
        case (.tmdb, .movieDetails):
            return TMDBMovieResponse.self
        default:
            return nil
        }
    }

    private func getPath(for endpoint: Endpoint) -> String {
        let endpointPath = endpoints[endpoint.rawValue] ?? ""
        return "\(endpointPath)\(endpoint.pathParameters)"
    }
}
