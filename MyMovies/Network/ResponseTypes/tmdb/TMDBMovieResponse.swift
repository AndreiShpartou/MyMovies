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
    var voteAverage: Double?
    var posterPath: String?
    var backdropPath: String?
    var genreIds: [Int]
    var genres: [TMDBGenreResponseProtocol]? {
        return movieGenres
    }
    private let movieGenres: [TMDBMovieResponse.Genre]?

    struct Genre: TMDBGenreResponseProtocol {
        var id: Int
        var name: String?
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, movieGenres
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }

    // MARK: - Public
    func posterURL(size: PosterSize = .w780) -> String? {
        guard let posterPath = posterPath else {
            return nil
        }

        return ImageURLBuilder.buildURL(for: posterPath, size: size)
    }

    func backdropURL(size: BackdropSize = .w780) -> String? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return ImageURLBuilder.buildURL(for: backdropPath, size: size)
    }
}
