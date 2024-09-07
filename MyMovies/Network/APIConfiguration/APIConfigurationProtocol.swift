//
//  APIConfigurationProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

protocol APIConfigurationProtocol {
    func isActive(endpoint: Endpoint) -> Bool
    func url(for endpoint: Endpoint) -> URL?
    func responseType(for endpoint: Endpoint) -> Codable.Type?
    func queryParameters(for endpoint: Endpoint) -> [String: Any]
    func authorizationHeader() -> [String: String]
}
