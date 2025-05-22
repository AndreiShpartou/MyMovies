//
//  NetworkService.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation
import Alamofire

final class NetworkService: NetworkServiceProtocol {

    static let shared = NetworkService()

    var apiConfig: APIConfigurationProtocol? {
        return AppConfigurationManager.shared.appConfig?.apiConfig
    }

    private lazy var provider = apiConfig?.getProvider() ?? .kinopoisk
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

    // Get movie details for each movie in the array (separate requests for each movie)
    func fetchMoviesDetails(for movies: [MovieProtocol], type: MovieListType, completion: @escaping ([MovieProtocol]) -> Void) {
        var detailedMoviesDict: [Int: MovieProtocol] = [:]
        let dispatchGroup = DispatchGroup()

        movies.forEach { movie in
            dispatchGroup.enter()
            fetchMovieDetails(for: movie, type: type) { result in
                switch result {
                case .success(let detailedMovie):
                    // Store by ID
                    detailedMoviesDict[detailedMovie.id] = detailedMovie
                case .failure(let error):
                    debugPrint(error)
                    // Store the original movie if fetch failed
                    detailedMoviesDict[movie.id] = movie
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            // Sort movies by the original order
            let detailedMovies = movies.compactMap { detailedMoviesDict[$0.id] }
            completion(detailedMovies)
        }
    }

    // Get movie details by array of id (single request for all movies)
    // For now, only Kinopoisk API supported
    func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol], completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success(defaultValue))
            return
        }

        let encoding = URLEncoding(arrayEncoding: .noBrackets)
        performRequest(for: .moviesDetails(ids: ids), defaultValue: defaultValue as? [Movie], encoding: encoding) { (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                // Movie details may appear in a different order. Therefore, we have to sort them
                // Build a dictionary: movie ID -> movie
                let moviesDictionary = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
                // Sort movies by the original order of IDs
                let sortedMovies = ids.compactMap { moviesDictionary[$0] }
                completion(.success(sortedMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - MoviesFilteredByGenre
    func fetchMoviesByGenre(type: MovieListType, genre: GenreProtocol, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        let queryParameters = getGenreQueryParameters(for: genre, endpoint: type.endpoint)
        fetchMoviesWithParameters(type: type, parameters: queryParameters, completion: completion)
    }

    // MARK: - PersonDetails
    // Get details for a specific person
    func fetchPersonDetails(for personID: Int, completion: @escaping (Result<PersonDetailed, Error>) -> Void) {
        performRequest(for: .personDetails(id: personID)) { (result: Result<PersonDetailed, Error>) in
            switch result {
            case .success(let personDetails):
                completion(.success(personDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - PersonRelatedMovies
    // Get movies related to a specific person
    func fetchPersonRelatedMovies(for personID: Int, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        performRequest(for: .personRelatedMovies(id: personID)) { (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Genres
    // Get the list of official genres for movies
    func fetchGenres(completion: @escaping (Result<[GenreProtocol], Error>) -> Void) {
        performRequest(for: .genres) { (result: Result<[Genre], Error>) in
            switch result {
            case .success(let genres):
                completion(.success(genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Reviews
    func fetchReviews(for movieID: Int, completion: @escaping (Result<[MovieReview], Error>) -> Void) {
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
    func fetchSettingsSections(completion: @escaping (Result<[ProfileSettingsSection], Error>) -> Void) {
        let settingsSection: [ProfileSettingsSection] = [
            ProfileSettingsSection(title: "General", items: [.notification, .language]),
            ProfileSettingsSection(title: "More", items: [.legalAndPolicies, .aboutUs])
        ]
        completion(.success(settingsSection))
    }

    // MARK: - Search
    func searchMovies(query: String, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        searchItems(endpoint: .searchMovies(query: query)) { (result: Result<[Movie], Error>) in
            completion(result.map { $0 as [MovieProtocol] })
        }
    }

    func searchPersons<T: PersonProtocol>(query: String, completion: @escaping (Result<[T], Error>) -> Void) {
        searchItems(endpoint: .searchPersons(query: query)) { (result: Result<[T], Error>) in
            completion(result.map { $0 as [T] })
        }
    }

    // MARK: - Provider
    func getProvider() -> Provider {
        return provider
    }

    // MARK: - Private PerformRequest
    //  Versatile request performer
    private func performRequest<T: Codable>(
        for endpoint: Endpoint,
        queryParameters: [String: Any] = [:],
        // For the case when an endpoint is non-active for current API provider
        defaultValue: T? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let apiConfig = apiConfig else {
            completion(.failure(CustomNetworkError.invalidAPIConfig))

            return
        }

        guard apiConfig.isActive(endpoint: endpoint) else {
            guard let defaultValue = defaultValue else {
                completion(.failure(CustomNetworkError.invalidAPIConfig))

                return
            }

            // Return initial value without endpoint request performing
            completion(.success(defaultValue))

            return
        }

        guard let url = apiConfig.url(for: endpoint) else {
            completion(.failure(CustomNetworkError.invalidURL))

            return
        }

        guard let responseType = apiConfig.responseType(for: endpoint) else {
            completion(.failure(CustomNetworkError.invalidResponseType))

            return
        }
        // Get default endpoint query parameters
        var parameters = apiConfig.defaultQueryParameters(for: endpoint)
        // Add passed parameters
        parameters.merge(queryParameters) { _, new in new }

        // Check the cache
        let cacheKey = makeCacheKey(url: url, parameters: parameters)
        if let cachedData = APICache.shared.retrieve(for: cacheKey) {
            // parse from cache
            let afResponse = AFDataResponse(
                request: nil,
                response: nil,
                data: nil,
                metrics: nil,
                serializationDuration: TimeInterval(0),
                result: .success(cachedData)
            )
            handleResponse(afResponse, ofType: responseType, cacheKey: nil, completion: completion)

            return
        }

        // Apply auth
        let headers = HTTPHeaders(apiConfig.authorizationHeader())
        // Do network
        AF.request(url, parameters: parameters, encoding: encoding, headers: headers).responseData { [weak self] response in
            self?.handleResponse(response, ofType: responseType, cacheKey: cacheKey, completion: completion)
        }
    }
    // MARK: - HandleResponse
    private func handleResponse<T: Codable>(
        _ response: AFDataResponse<Data>,
        ofType responseType: Codable.Type,
        cacheKey: String?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Check for 403 / Public token's limits
        if provider == .kinopoisk,
           let statusCode = response.response?.statusCode,
           statusCode == 403 {
            completion(.failure(CustomNetworkError.forbidden))

            return
        }

        switch response.result {
        case .success(let data):
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                let mappedData = try mapper.map(data: decodedResponse, from: responseType, to: T.self)
                // Update cache
                if let cacheKey = cacheKey {
                    APICache.shared.store(data, for: cacheKey)
                }

                completion(.success(mappedData))
            } catch let decodingError as DecodingError {
                debugPrint(decodingError)
                completion(.failure(decodingError))
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

    // MARK: - SearchItems
    private func searchItems<T: Codable>(
        endpoint: Endpoint,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        performRequest(for: endpoint, encoding: encoding, completion: completion)
    }

    private func makeCacheKey(url: URL, parameters: [String: Any]) -> String {
        let sortedParams = parameters
            .map { "\($0.key)=\($0.value)" }
            .sorted()
            .joined(separator: "&")

        let base = url.absoluteString
        let combined = "\(base)?\(sortedParams)"

        return combined
    }
}
