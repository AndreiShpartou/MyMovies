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
    // Get the list of official genres for movies
    case genres
    // Get a list of movies by type
    case movieList(type: MovieListType)
    // Get the movie details by ID
    case movieDetails(id: Int, type: MovieListType? = nil)
    // Get the details for an array of movie IDs
    case moviesDetails(ids: [Int])
    // Get the movie reviews
    case reviews(id: Int)
    // Get person details
    case personDetails(id: Int)
    // Get person related movies
    case personRelatedMovies(id: Int)
    // Search movies
    case searchMovies(query: String)
    // Search persons
    case searchPersons(query: String)

    var rawValue: String {
        switch self {
        case .genres:
            return "genres"
        case .movieList(let type):
            return type.rawValue
        // Utilize one separate request for one movie
        case .movieDetails,
        // .moviesDetails - Utilize the same endpoint but with different query parameters
        // One request with [Ids] parameter for all movies
        // Available only for Kinopoisk API, for now
                .moviesDetails:
            return "movieDetails"
        case .reviews:
            return "reviews"
        case .personDetails:
            return "personDetails"
        case .personRelatedMovies:
            return "personRelatedMovies"
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

    func getProvider() -> Provider {
        return provider
    }

    // MARK: - Private
    private func isActive(endpoint: Endpoint, for provider: Provider) -> Bool {
        switch (provider, endpoint) {
        case (.kinopoisk, .movieDetails(_, type: .popularMovies)),
            (.kinopoisk, .movieDetails(_, type: .upcomingMovies)),
            (.kinopoisk, .movieDetails(_, type: .topRatedMovies)),
            (.kinopoisk, .movieDetails(_, type: .theHighestGrossingMovies)),
            (.kinopoisk, .movieDetails(_, type: .searchedMovies)),
            (.kinopoisk, .movieDetails(_, type: .similarMovies)),
            (.kinopoisk, .movieDetails(_, type: .personRelatedMovies)),
            (.kinopoisk, .movieDetails(_, type: nil)):
            return false
        case (.tmdb, .moviesDetails):
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
             (.tmdb, .movieList(type: .similarMovies)),
            (.tmdb, .movieList(type: .searchedMovies)),
            (.tmdb, .movieList(type: .personRelatedMovies)),
            (.tmdb, .searchMovies),
            (.tmdb, .personRelatedMovies):
            return TMDBMoviesPagedResponse.self
        case (.kinopoisk, .movieList(type: .upcomingMovies)),
            (.kinopoisk, .movieList(type: .popularMovies)),
            (.kinopoisk, .movieList(type: .topRatedMovies)),
            (.kinopoisk, .movieList(type: .theHighestGrossingMovies)),
            (.kinopoisk, .movieList(type: .searchedMovies)),
             (.kinopoisk, .movieList(type: .personRelatedMovies)),
            (.kinopoisk, .movieList(type: .similarMovies)),
            (.kinopoisk, .searchMovies),
            (.kinopoisk, .moviesDetails),
            (.kinopoisk, .personRelatedMovies):
            return KinopoiskMoviesPagedResponse.self
        case (.tmdb, .movieDetails):
            return TMDBMovieResponse.self
        case (.tmdb, .reviews):
            return TMDBReviewsPagedResponse.self
        case (.kinopoisk, .reviews):
            return KinopoiskReviewsPagedResponse.self
        case (.tmdb, .personDetails):
            return TMDBPersonDetailedResponse.self
        case (.kinopoisk, .personDetails):
            return KinopoiskPersonDetailedResponse.self
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
//        case (.kinopoisk, .movieDetails(let id, .similarMovies)):
//            let queryParameters: [String: Any] = ["id": String(id)]
//            return queryParameters
        case (.kinopoisk, .movieList(type: .similarMovies(let id))):
            let queryParameters: [String: Any] = ["id": String(id)]
            return queryParameters
        case (.kinopoisk, .moviesDetails(let ids)):
            let queryParameters: [String: Any] = ["id": ids.map { String($0) }]
            return queryParameters
        case (.kinopoisk, .personRelatedMovies(let id)),
            (.kinopoisk, .movieList(type: .personRelatedMovies(let id))):
            let queryParameters: [String: Any] = ["persons.id": String(id)]
            return queryParameters
        case (.tmdb, .personRelatedMovies(let id)),
            (.tmdb, .movieList(type: .personRelatedMovies(let id))):
            let queryParameters: [String: Any] = ["with_people": String(id)]
            return queryParameters
        case (.tmdb, .searchMovies(let query)),
            (.tmdb, .searchPersons(let query)),
            (.kinopoisk, .searchMovies(let query)),
            (.kinopoisk, .searchPersons(let query)),
            (.tmdb, .movieList(type: .searchedMovies(let query))),
            (.kinopoisk, .movieList(type: .searchedMovies(let query))):
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
            (.tmdb, .movieList(type: .theHighestGrossingMovies)),
            (.tmdb, .movieList(type: .personRelatedMovies)):
            guard let genreID = genre.id else {
                return [:]
            }
            let queryParameters: [String: Any] = ["with_genres": genreID]

            return queryParameters
        case (.kinopoisk, .movieList(type: .upcomingMovies)),
            (.kinopoisk, .movieList(type: .popularMovies)),
            (.kinopoisk, .movieList(type: .topRatedMovies)),
            (.kinopoisk, .movieList(type: .theHighestGrossingMovies)),
             (.kinopoisk, .movieList(type: .personRelatedMovies)):
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
        case (_, .personDetails(let id)):
            return "\(id)"
        default:
            return ""
        }
    }
}
