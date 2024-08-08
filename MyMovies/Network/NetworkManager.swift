//
//  NetworkManager.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // Fetch movie lists
    func fetchMovieLists(completion: @escaping (Result<MovieListsPagedResponse, Error>) -> Void) {
        guard let url = APIEndpoint.movieLists.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let headers: HTTPHeaders = [
            "X-API-KEY": "CD1F5E2-EHGM43S-NGWDFK8-5EQGH6A"
        ]

        AF.request(url, headers: headers).responseDecodable(of: MovieListsPagedResponse.self) { response in
            switch response.result {
            case .success(let movieLists):
                completion(.success(movieLists))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

//    // Fetch movie lists for category
//    func fetchMovieLists(category: Category, completion: @escaping (Result<MovieListsPagedResponse, Error>) -> Void) {
//        guard let url = APIEndpoint.movieLists.url else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//
//        let headers: HTTPHeaders = [
//            "X-API-KEY": "CD1F5E2-EHGM43S-NGWDFK8-5EQGH6A"
//        ]
//
//        AF.request(url, headers: headers).responseDecodable(of: MovieListsPagedResponse.self) { response in
//            switch response.result {
//            case .success(let movieLists):
//                completion(.success(movieLists))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }

    // Fetch top movies
    func fetchTopMovies(completion: @escaping (Result<MoviesPagedResponse, Error>) -> Void) {
        guard let url = APIEndpoint.popularMovies.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let headers: HTTPHeaders = [
            "X-API-KEY": "CD1F5E2-EHGM43S-NGWDFK8-5EQGH6A"
        ]

        AF.request(url, headers: headers).responseDecodable(of: MoviesPagedResponse.self) { response in
            switch response.result {
            case .success(let movieLists):
                completion(.success(movieLists))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
