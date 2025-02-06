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
    // Get a list of movies by type
    case movieList(type: MovieListType)
    // Get the list of official genres for movies
    case genres
    // Get the movie details by ID
    case movieDetails(id: Int, type: MovieListType? = nil)
    // Get the movie reviews
    case reviews(id: Int)
    // Search movies
    case searchMovies(query: String)
    // Search persons
    case searchPersons(query: String)

    var rawValue: String {
        switch self {
        case .movieList(let type):
            return type.rawValue
        case .genres:
            return "genres"
        case .movieDetails:
            return "movieDetails"
        case .reviews:
            return "reviews"
        case .searchMovies:
            return "searchMovies"
        case .searchPersons:
            return "searchPersons"
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
        guard let path = getPath(for: endpoint).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        return URL(string: "\(baseURL.absoluteString)\(path)")
    }

    func responseType(for endpoint: Endpoint) -> Codable.Type? {
        return getResponseType(for: endpoint, and: provider)
    }

    func defaultQueryParameters(for endpoint: Endpoint) -> [String: Any] {
        return getQueryParameters(for: endpoint, and: provider)
    }

    func genreFilteringQueryParameters(for genre: GenreProtocol, endpoint: Endpoint) -> [String: Any] {
        return getGenreQueryParameters(for: genre, endpoint: endpoint, and: provider)
    }

    func authorizationHeader() -> [String: String] {
        return authHeader
    }

    func getProviderAPI() -> Provider {
        return provider
    }

    // MARK: - Private
    private func isActive(endpoint: Endpoint, for provider: Provider) -> Bool {
        switch (provider, endpoint) {
        case (.kinopoisk, .movieDetails(_, type: .popularMovies)),
            (.kinopoisk, .movieDetails(_, type: .upcomingMovies)),
            (.kinopoisk, .movieDetails(_, type: .topRatedMovies)),
            (.kinopoisk, .movieDetails(_, type: .theHighestGrossingMovies)),
            (.kinopoisk, .movieDetails(_, type: nil)):
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
        case (.tmdb, .movieList(type: .upcomingMovies)),
            (.tmdb, .movieList(type: .popularMovies)),
            (.tmdb, .movieList(type: .topRatedMovies)),
            (.tmdb, .movieList(type: .theHighestGrossingMovies)),
            (.tmdb, .movieList(type: .similarMovies)):
            return TMDBMoviesPagedResponse.self
        case (.kinopoisk, .movieList(type: .upcomingMovies)),
            (.kinopoisk, .movieList(type: .popularMovies)),
            (.kinopoisk, .movieList(type: .topRatedMovies)),
            (.kinopoisk, .movieList(type: .theHighestGrossingMovies)):
            return KinopoiskMoviesPagedResponse.self
        case (.tmdb, .movieDetails):
            return TMDBMovieResponse.self
        case (.kinopoisk, .movieDetails):
            return KinopoiskMovieResponse.self
        case (.tmdb, .reviews):
            return TMDBReviewsPagedResponse.self
        case (.kinopoisk, .reviews):
            return KinopoiskReviewsPagedResponse.self
        case (.tmdb, .searchMovies):
            return TMDBMoviesPagedResponse.self
        case (.kinopoisk, .searchMovies):
            return KinopoiskMoviesPagedResponse.self
        case (.tmdb, .searchPersons):
            return TMDBPersonsPagedResponse.self
        case (.kinopoisk, .searchPersons):
            return KinopoiskPersonsPagedResponse.self
        default:
            return nil
        }
    }

    private func getQueryParameters(for endpoint: Endpoint, and provider: Provider) -> [String: Any] {
        switch (provider, endpoint) {
        case (.tmdb, .movieList(type: .upcomingMovies)):
            // Get the date range for premier
            let currentDate = Date()
            guard let monthAheadDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate),
                  let minDate = getNearestWednesday(from: currentDate),
                  let maxDate = getNearestWednesday(from: monthAheadDate) else {
                return [:]
            }

            let queryParameters: [String: Any] = [
                "release_date.gte": formatDate(minDate),
                "release_date.lte": formatDate(maxDate)
            ]

            return queryParameters
        case (.kinopoisk, .reviews(let id)):
            let queryParameters: [String: Any] = ["movieId": String(id)]
            return queryParameters
//        Moved to path parameters
//        case (.kinopoisk, .movieDetails(let id, .similarMovies)):
//            let queryParameters: [String: Any] = ["id": String(id)]
//            return queryParameters
        case (.tmdb, .searchMovies(let query)),
                (.tmdb, .searchPersons(let query)),
                 (.kinopoisk, .searchMovies(let query)),
                  (.kinopoisk, .searchPersons(let query)):
            let queryParameters: [String: Any] = ["query": query.trimmingCharacters(in: .whitespaces)]
                return queryParameters
        default:
            return [:]
        }
    }

    private func getGenreQueryParameters(for genre: GenreProtocol, endpoint: Endpoint, and provider: Provider) -> [String: Any] {
        switch (provider, endpoint) {
        case (.tmdb, .movieList(type: .upcomingMovies)),
            (.tmdb, .movieList(type: .popularMovies)),
            (.tmdb, .movieList(type: .topRatedMovies)),
            (.tmdb, .movieList(type: .theHighestGrossingMovies)):
            guard let genreID = genre.id else {
                return [:]
            }
            let queryParameters: [String: Any] = ["with_genres": genreID]

            return queryParameters
        case (.kinopoisk, .movieList(type: .upcomingMovies)),
            (.kinopoisk, .movieList(type: .popularMovies)),
            (.kinopoisk, .movieList(type: .topRatedMovies)),
            (.kinopoisk, .movieList(type: .theHighestGrossingMovies)):
            guard let genreName = genre.rawName,
                  let defaultAllGenresName = DefaultValue.genre.rawName,
                    genreName != defaultAllGenresName else {
                return [:]
            }
            let queryParameters: [String: Any] = ["genres.name": genreName]

            return queryParameters
        default:
            return [:]
        }
    }

    private func getPath(for endpoint: Endpoint) -> String {
        let endpointPath = endpoints[endpoint.rawValue] ?? ""
        let pathParameters = getPathParameters(for: endpoint, and: provider)
        return "\(endpointPath)\(pathParameters)"
    }

    private func getPathParameters(for endpoint: Endpoint, and provider: Provider) -> String {
        switch (provider, endpoint) {
        case (.tmdb, .movieDetails(let id, _)):
            return "\(id)?append_to_response=credits"
        case (.tmdb, .reviews(let id)):
            return "\(id)/reviews"
        case (.tmdb, .movieList(type: .similarMovies(let id))):
            return "\(id)/similar"
        case (.kinopoisk, .movieDetails(let id, .similarMovies)):
            return "\(id)"
        default:
            return ""
        }
    }
}
