//
//  MovieListsPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

struct MovieListsPagedResponse: Codable, PagedResponseProtocol {
    var docs: [MovieList]
    var total: Int
    var limit: Int
    var page: Int
    var pages: Int
}
