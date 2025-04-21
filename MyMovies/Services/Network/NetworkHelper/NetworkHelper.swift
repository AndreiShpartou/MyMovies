//
//  NetworkHelper.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 14/08/2024.
//
import Foundation
import Alamofire

// Additional network methods
final class NetworkHelper: NetworkHelperProtocol {
    static let shared = NetworkHelper()

    private init() {}

    func getPublicIPAddress(completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://api.ipify.org?format=json"

        let responseQueue = DispatchQueue.global(qos: .userInitiated)
        AF.request(urlString).response(queue: responseQueue) { response in
            switch response.result {
            case .success(let data):
                do {
                    if let data = data,
                       let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let ip = json["ip"] as? String {
                        completion(.success(ip))
                    } else {
                        completion(.failure(CustomNetworkError.failedToGetData))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCountry(for ip: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "IpifyAccessToken") as? String else {
            return
        }

        let urlString = "https://ipinfo.io/\(ip)/country?token=\(accessToken)"

        let responseQueue = DispatchQueue.global(qos: .userInitiated)
        AF.request(urlString).responseString(queue: responseQueue) { response in
            switch response.result {
            case .success(let country) where !country.contains("error"):
                completion(.success(country.trimmingCharacters(in: .whitespacesAndNewlines)))
            case .failure(let error):
                completion(.failure(error))
            default:
                completion(.failure(CustomNetworkError.failedToGetData))
            }
        }
    }
}

// MARK: - Default Network Errors
enum CustomNetworkError: Error, LocalizedError {
    case failedToCreateRequest
    case failedToGetData
    case invalidURL
    case invalidJSON
    case invalidAPIConfig
    case invalidResponseType

    var errorDescription: String? {
        switch self {
        case .failedToCreateRequest:
            return NSLocalizedString("Failed to create request", comment: "")
        case .failedToGetData:
            return NSLocalizedString("Failed to get data", comment: "")
        case .invalidURL:
            return NSLocalizedString("Failed to create url. Invalid URL format", comment: "")
        case .invalidJSON:
            return NSLocalizedString("Invalid JSON structure", comment: "")
        case .invalidAPIConfig:
            return NSLocalizedString("Invalid API config", comment: "")
        case .invalidResponseType:
            return NSLocalizedString("Invalid response type", comment: "")
        }
    }
}
