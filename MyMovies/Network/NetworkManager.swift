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
// nowisthetime - Сейчас самое время (category - Онлайн-кинотеатр)
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

    func performRequest<T: Codable>(for endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let apiConfig = apiConfig else {
            completion(.failure(NetworkError.invalidAPICOnfig))
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

        // Apply auth
        let headers = HTTPHeaders(apiConfig.authorizationHeader())
        // Apply additional headers
        // headers.headers.append(//)

        AF.request(url, headers: headers).responseData { [weak self] response in
            self?.handleResponse(response, ofType: responseType, completion: completion)
        }
    }

    // Fetch genres
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
                } catch _ as DecodingError {
                    completion(.failure(NetworkError.invalidJSON))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }

    
//    // Fetch movie lists
//    func fetchMovieLists(completion: @escaping (Result<TMDBMovieListsPagedResponse, Error>) -> Void) {
//        performRequest(for: .popularMovies, completion: completion)
//    }
//
//    // Fetch top movies
//    func fetchTopMovies(completion: @escaping (Result<TMDBMoviesPagedResponse, Error>) -> Void) {
//        performRequest(for: .trendingMovies, completion: completion)
//    }

//    // Fetch movie lists
//    func fetchMovieLists(completion: @escaping (Result<TMDBMovieListsPagedResponse, Error>) -> Void) {
//        guard let url = APIEndpoint.movieLists.url else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(APIEndpoint.readAccessToken)"
//        ]
//
//        let parameters: Parameters = [
//            "language": "en-US",
//            "query": "collection"
//        ]
//
//        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: TMDBMovieListsPagedResponse.self) { response in
//            switch response.result {
//            case .success(let movieLists):
//                completion(.success(movieLists))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }

//    // Fetch genres
//    func fetchGenres(completion: @escaping (Result<TMDBGenresResponse, Error>) -> Void) {
//
//        guard let url = APIEndpoint.genres.url else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(APIEndpoint.readAccessToken)"
//        ]
//
//        AF.request(url, headers: headers).responseDecodable(of: TMDBGenresResponse.self) { response in
//            switch response.result {
//            case .success(let genres):
//                completion(.success(genres))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }

//    // Fetch top movies
//    func fetchTopMovies(completion: @escaping (Result<TMDBMoviesPagedResponse, Error>) -> Void) {
//        guard let url = APIEndpoint.popularMovies.url else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//
//        let headers: HTTPHeaders = [
//            "X-API-KEY": "CD1F5E2-EHGM43S-NGWDFK8-5EQGH6A"
//        ]
//
//        AF.request(url, headers: headers).responseDecodable(of: TMDBMoviesPagedResponse.self) { response in
//            switch response.result {
//            case .success(let movieLists):
//                completion(.success(movieLists))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
