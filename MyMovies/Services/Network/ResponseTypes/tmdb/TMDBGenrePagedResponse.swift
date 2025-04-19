//
//  TMDBGenrePagedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 09/08/2024.
//

import Foundation

struct TMDBGenrePagedResponse: TMDBGenrePagedResponseProtocol {
    var genres: [TMDBGenreResponseProtocol] {
        return movieGenres
    }

    enum CodingKeys: String, CodingKey {
        case movieGenres = "genres"
    }

    private let movieGenres: [TMDBMovieResponse.Genre]
}
