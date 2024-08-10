//
//  GenresResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 09/08/2024.
//

import Foundation

struct GenresResponse: Codable {
    let data: [Genre]
    let status: String
}
