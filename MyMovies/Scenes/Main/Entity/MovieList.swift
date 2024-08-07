//
//  MovieList.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import Foundation

struct MovieList: Codable {
    let id: String
    let category: MovieCategory
    let name: String
    let moviesCount: Int?
    let cover: Cover?
}

struct MovieCategory: Codable {
    let category: String
}
