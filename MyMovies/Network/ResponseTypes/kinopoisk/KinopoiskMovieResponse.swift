//
//  KinopoiskMovieResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

struct KinopoiskMovieResponse: KinopoiskMovieResponseProtocol {
    var id: Int
    var name: String
    var alternativeName: String?
    var enName: String?
    var type: String
    var year: Int
    var description: String?
    var shortDescription: String?
    var movieLength: Int?
    var poster: KinopoiskCoverResponseProtocol? {
        moviePoster
    }
    var backdrop: KinopoiskCoverResponseProtocol? {
        return movieBackdrop
    }
    var genres: [KinopoiskGenreResponseProtocol] {
        return movieGenres
    }
    var rating: KinopoiskRatingResponseProtocol? {
        return movieRating
    }

    struct Cover: KinopoiskCoverResponseProtocol {
        var url: String?
        var previewUrl: String?
    }

    struct Genre: KinopoiskGenreResponseProtocol {
        var name: String
    }

    struct Rating: KinopoiskRatingResponseProtocol {
        var kp: Float?
    }

    enum CodingKeys: String, CodingKey {
        case id, name, alternativeName, enName, type, year, description, shortDescription, movieLength
        case moviePoster = "poster"
        case movieBackdrop = "backdrop"
        case movieGenres = "genres"
        case movieRating = "rating"
    }

    // MARK: - Private
    private let moviePoster: KinopoiskMovieResponse.Cover?
    private let movieBackdrop: KinopoiskMovieResponse.Cover?
    private let movieGenres: [KinopoiskMovieResponse.Genre]
    private let movieRating: KinopoiskMovieResponse.Rating?
}
