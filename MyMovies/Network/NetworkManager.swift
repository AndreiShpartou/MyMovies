//
//  NetworkManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation
import Alamofire

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()

    var apiConfig: APIConfigurationProtocol? {
        return AppConfigurationManager.shared.appConfig?.apiConfig
    }

    private let mapper: ResponseMapperProtocol = ResponseMapper()

    private init() {}

    // MARK: - FetchMovies
    // Fetch list of movies by type
    func fetchMovies(type: MovieListType, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        fetchMoviesWithParameters(type: type, completion: completion)
    }

    // MARK: - MovieDetails
    // Get movie details for a specific movie
    func fetchMovieDetails(for movie: MovieProtocol, type: MovieListType, completion: @escaping (Result<MovieProtocol, Error>) -> Void) {
        performRequest(for: .movieDetails(id: movie.id, type: type), defaultValue: movie as? Movie) { (result: Result<Movie, Error>) in
            switch result {
            case .success(let movie):
                completion(.success(movie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Get movie details for an array of movies
    func fetchMoviesDetails(for movies: [MovieProtocol], type: MovieListType, completion: @escaping ([MovieProtocol]) -> Void) {
        var detailedMovies = [MovieProtocol]()
        let dispatchGroup = DispatchGroup()

        movies.forEach { movie in
            dispatchGroup.enter()
            fetchMovieDetails(for: movie, type: type) { result in
                switch result {
                case .success(let detailedMovie):
                    detailedMovies.append(detailedMovie)
                case .failure:
                    // TODO: Error handling
                    detailedMovies.append(movie)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(detailedMovies)
        }
    }

    // MARK: - MoviesFilteredByGenre
    func fetchMoviesByGenre(type: MovieListType, genre: GenreProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        let queryParameters = getGenreQueryParameters(for: genre, endpoint: type.endpoint)
        fetchMoviesWithParameters(type: type, parameters: queryParameters, completion: completion)
    }

    // MARK: - Genres
    // Get the list of official genres for movies
    func fetchGenres(completion: @escaping (Result<[GenreProtocol], Error>) -> Void) {
        performRequest(for: .genres) { (result: Result<[Movie.Genre], Error>) in
            switch result {
            case .success(let genres):
                completion(.success(genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Reviews
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReviewProtocol], Error>) -> Void) {
        performRequest(for: .reviews(id: movieID)) { (result: Result<[MovieReview], Error>) in
            switch result {
            case .success(let reviews):
                completion(.success(reviews))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - ProfileSettings
    func fetchUserProfile(completion: () -> Void) {
        //
    }

    func fetchSettingsSections(completion: @escaping (Result<[ProfileSettingsSection], Error>) -> Void) {
        let settingsSection: [ProfileSettingsSection] = [
            ProfileSettingsSection(title: "General", items: [.notification, .language]),
            ProfileSettingsSection(title: "More", items: [.legalAndPolicies, .aboutUs])
        ]
        completion(.success(settingsSection))
    }

    // MARK: - PerformRequest
    //  Versatile request performer
    private func performRequest<T: Codable>(
        for endpoint: Endpoint,
        queryParameters: [String: Any] = [:],
        // For the case when an endpoint is non-active for current API provider
        defaultValue: T? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let apiConfig = apiConfig else {
            completion(.failure(NetworkError.invalidAPIConfig))
            return
        }

        guard apiConfig.isActive(endpoint: endpoint) else {
            guard let defaultValue = defaultValue else {
                completion(.failure(NetworkError.invalidAPIConfig))
                return
            }

            // Return initial value without endpoint request performing
            completion(.success(defaultValue))
            return
        }

        guard let url = apiConfig.url(for: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        guard let responseType = apiConfig.responseType(for: endpoint) else {
            completion(.failure(NetworkError.invalidResponseType))
            return
        }
        // Get default endpoint query parameters
        var parameters = apiConfig.defaultQueryParameters(for: endpoint)
        // Add passed parameters
        parameters.merge(queryParameters) { _, new in new }

        // Apply auth
        let headers = HTTPHeaders(apiConfig.authorizationHeader())
        // Apply additional headers
        // headers.headers.append(//)

        AF.request(url, parameters: parameters, headers: headers).responseData { [weak self] response in
            self?.handleResponse(response, ofType: responseType, completion: completion)
        }
    }
    // MARK: - HandleResponse
    private func handleResponse<T: Codable>(
        _ response: AFDataResponse<Data>,
        ofType responseType: Codable.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        switch response.result {
        case .success(let data):
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                let mappedData = try mapper.map(data: decodedResponse, from: responseType, to: T.self)
                completion(.success(mappedData))
            } catch let decodingError as DecodingError {
                print(decodingError)
                completion(.failure(NetworkError.invalidJSON))
            } catch {
                completion(.failure(error))
            }

        case .failure(let error):
            completion(.failure(error))
        }
    }

    // MARK: - MoviesWithParameters
    private func fetchMoviesWithParameters(type: MovieListType, parameters: [String: Any] = [:], completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        performRequest(for: type.endpoint, queryParameters: parameters) { (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - GenreFiltering
    private func getGenreQueryParameters(for genre: GenreProtocol, endpoint: Endpoint) -> [String: Any] {
        return apiConfig?.genreFilteringQueryParameters(for: genre, endpoint: endpoint) ?? [:]
    }
}
