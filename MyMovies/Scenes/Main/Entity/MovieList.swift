//
//  MovieList.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import Foundation

struct MovieList: Codable {
    let category: String
    let moviesCont: Int
    let cover: Cover
    let name: String
}
