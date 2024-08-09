//
//  MovieListsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

struct MovieListsPagedResponse: Codable, PagedResponseProtocol {
    var page: Int
    var results: [MovieList]
    var total_pages: Int
    var total_results: Int
}
