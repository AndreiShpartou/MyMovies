//
//  TMDBGenrePagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 09/08/2024.
//

import Foundation

struct TMDBGenrePagedResponse: TMDBGenrePagedResponseProtocol {
    var genres: [TMDBGenreResponse]
}
