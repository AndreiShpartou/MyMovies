//
//  APIEndpoint.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://api.kinopoisk.dev"

    case movieLists
    case popularMovies

    var urlString: String {
        switch self {
        case .movieLists:
            return "\(APIEndpoint.baseURL)/v1.4/list"
        case .popularMovies:
            return "\(APIEndpoint.baseURL)/v1.4/movie?lists=popular-films"
        }
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
