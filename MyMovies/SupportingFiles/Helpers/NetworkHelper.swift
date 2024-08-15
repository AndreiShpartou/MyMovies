//
//  NetworkHelper.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 14/08/2024.
//
import Foundation
import Alamofire
import ipinfoKit

final class NetworkHelper {
    static let shared = NetworkHelper()

    private init() {}

    func getPublicIPAddress(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "GetIP_API") as? String else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                do {
                    if let data = data,
                       let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let ip = json["ip"] as? String {
                        completion(.success(ip))
                    }
                } catch {
                    completion(.failure(NetworkError.invalidJSON))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Default RMService Errors
enum NetworkError: Error, LocalizedError {
    case failedToCreateRequest
    case failedToGetData
    case invalidURL
    case invalidJSON

    var errorDescription: String? {
        switch self {
        case .failedToCreateRequest:
            return NSLocalizedString("Failed to create request", comment: "Network")
        case .failedToGetData:
            return NSLocalizedString("Failed to get data", comment: "Network")
        case .invalidURL:
            return NSLocalizedString("Failed to create url. Invalid URL format", comment: "Network")
        case .invalidJSON:
            return NSLocalizedString("Invalid JSON structure", comment: "Network")
        }
    }
}
