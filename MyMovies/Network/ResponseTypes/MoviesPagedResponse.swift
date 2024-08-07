//
//  MoviesPagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/08/2024.
//

import Foundation

struct MoviesPagedResponse: Codable, PagedResponseProtocol {
    var docs: [Movie]
    var total: Int
    var limit: Int
    var page: Int
    var pages: Int
}
