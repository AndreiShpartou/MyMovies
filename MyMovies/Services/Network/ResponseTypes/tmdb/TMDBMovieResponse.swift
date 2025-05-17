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
    var status: String?
    var tagline: String?
    var releaseDate: String?
    var runtime: Int?
    var voteAverage: Double?
    var posterPath: String?
    var backdropPath: String?
    var genreIds: [Int]?
    var genres: [TMDBGenreResponse]?
    var countries: [TMDBCountryResponse]?
    var credits: TMDBCreditsResponse?

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

struct TMDBGenreResponse: TMDBGenreResponseProtocol {
    var id: Int
    var name: String?
}

struct TMDBCountryResponse: TMDBCountryResponseProtocol {
    var iso_3166_1: String
    var name: String
}

struct TMDBCreditsResponse: TMDBCreditsResponseProtocol {
    var cast: [TMDBPersonResponse]?
    var crew: [TMDBPersonResponse]?
}
