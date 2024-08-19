//
//  TMDBMovieListsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

struct TMDBMovieListsPagedResponse: Codable, TMDBPagedResponseProtocol {
    var page: Int
    var results: [MovieList]
    var total_pages: Int
    var total_results: Int
}
