//
//  APIEndpoint.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://api.themoviedb.org"
    static let readAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1Y2M2MWUzNDBkMjY5MDNhZWU0ZjY0ZGE3ZTVjNGI5NSIsIm5iZiI6MTcyMzE5MjU3Ny41NjEzODUsInN1YiI6IjY2YjRjZGFhODE1NGZiNDUyODQyMjg4YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.k53MZ15xdf7y_pELfdqvAE4HYXbsiODWKiTWF-fW-JM"

    case genres
    case movieLists
    case popularMovies

    var urlString: String {
        switch self {
        case .movieLists:
            return "\(APIEndpoint.baseURL)/v1.4/list"
        case .genres:
            return "\(APIEndpoint.baseURL)/3/genre/movie/list"
        case .popularMovies:
            return "\(APIEndpoint.baseURL)/v1.4/movie?lists=popular-films"
        }
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
