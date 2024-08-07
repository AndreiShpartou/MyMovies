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
    case movieCategories
    case popularMovies

    var urlString: String {
        switch self {
        case .movieLists:
            return "\(APIEndpoint.baseURL)/v1.4/list"
        case .movieCategories:
            return "\(APIEndpoint.baseURL)/v1.4/list?limit=250&selectFields=category&sortType=-1&sortField=category"
        case .popularMovies:
            return "\(APIEndpoint.baseURL)/v1.4/list?slug=popular-films"
        }
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
