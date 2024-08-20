//
//  Movie.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/07/2024.
//

import Foundation

struct Movie: MovieProtocol, Codable {
    let id: Int // id
    let title: String // TMDB: title, Kinopoisk: name
    let alternativeTitle: String? // TMDB: original_title, Kinopoisk: alternativeName
    let description: String // TMDB: overview, Kinopoisk: description
    let releaseYear: String? // TMDB: release_date -> map, Kinopoisk: year -> map)
    let runtime: String?  // TMDB: runtime, Kinopoisk: movieLength
    let voteAverage: Float? //  TMDB: vote_average, Kinopoisk: rating.kp
    var genres: [GenreProtocol] {
        return movieGenres
    }
    var poster: CoverProtocol? {
        return moviePoster
    }
    var backdrop: CoverProtocol? {
        return movieBackdrop
    }

    private let movieGenres: [Genre]
    private let moviePoster: Cover? // TMDB: poster_path / Kinopoisk: poster.url
    private let movieBackdrop: Cover? // TMDB: backdrop_path / Kinopoisk: backdrop.url

    struct Genre: GenreProtocol, Codable {
        let id: Int? // TMDB
        let name: String
        let slug: String? // Kinopoisk
    }

    struct Cover: CoverProtocol, Codable {
        let url: String?
        let previewUrl: String?
    }
}
