//
//  MovieCollection.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 05/08/2024.
//

import Foundation

struct MovieCollection: Codable {
    let docs: [MovieList]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
}
