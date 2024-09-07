//
//  NetworkManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation
import Alamofire

// kinopoisk movie collections slug
// popular-films - Популярные фильмы (category - Фильмы)
// the_closest_releases - Ближайшие премьеры (category - Онлайн-кинотеатр)
// hd-must-see - Фильмы, которые стоит посмотреть (category - Онлайн-кинотеатр)
// top20of2023 - Топ-20 фильмов и сериалов 2023 года (category - Онлайн-кинотеатр)
// top10-hd - Топ 10 в онлайн-кинотеатре (category - Онлайн-кинотеатр)
// planned-to-watch-films - Рейтинг ожидаемых фильмов (category - Фильмы)
// top500 - 500 лучших фильмов (category - Фильмы)
// top250 - 250 лучших фильмов (category - Фильмы)

class NetworkManager {
    static let shared = NetworkManager()

    var apiConfig: APIConfigurationProtocol? {
        return AppConfigurationManager.shared.appConfig?.apiConfig
    }

    private let mapper: ResponseMapperProtocol = ResponseMapper()

    private init() {}

    //  Versatile request performer
    func performRequest<T: Codable>(
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
        var parameters = apiConfig.queryParameters(for: endpoint)
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

    // MARK: - UpcomingMovies
    // Get a list of movies that are being released soon.
    func fetchUpcomingMovies(completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        performRequest(for: .upcomingMovies) { (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - PopularMovies
    // Get a list of movies ordered by popularity
    func fetchPopularMovies(completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        performRequest(for: .popularMovies) { (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - MovieDetails
    // Get movie details for a specific movie ID
    func fetchMovieDetails(for movie: MovieProtocol, completion: @escaping (Result<MovieProtocol, Error>) -> Void) {
        performRequest(for: .movieDetails(id: movie.id), defaultValue: movie as? Movie) { (result: Result<Movie, Error>) in
            switch result {
            case .success(let movie):
                completion(.success(movie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
}
