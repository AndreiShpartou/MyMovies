//
//  MoviesPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

struct MoviesPagedResponse: Codable, PagedResponseProtocol {
    var page: Int
    var results: [Movie]
    var total_pages: Int
    var total_results: Int
}
