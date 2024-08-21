//
//  TMDBMovieResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

struct TMDBMovieResponse: TMDBMovieResponseProtocol {
    var id: Int
    var title: String
    var originalTitle: String?
    var overview: String?
    var releaseDate: String?
    var runtime: Int?
    var voteAverage: Float?
    var posterPath: String?
    var backdropPath: String?
    var genres: [TMDBGenreResponseProtocol] {
        return movieGenres
    }

    struct Genre: TMDBGenreResponseProtocol {
        var id: Int
        var name: String
    }

    enum CodingKeys: String, CodingKey {
        case id, title, originalTitle, overview, releaseDate, runtime, voteAverage, posterPath, backdropPath
        case movieGenres = "genres"
    }

    // MARK: - Private
    private let movieGenres: [TMDBMovieResponse.Genre]
}
