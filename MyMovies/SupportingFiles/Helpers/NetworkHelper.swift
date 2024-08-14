//
//  NetworkHelper.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 14/08/2024.
//

import Foundation
import Ipify

enum NetworkHelper {
    static func getPublicIPAddress(completion: @escaping (Result<String, Error>) -> Void) {
        Ipify.getPublicIPAddress { result in
            switch result {
            case .success(let ip):
                DispatchQueue.main.async {
                    completion(.success(ip))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
}
