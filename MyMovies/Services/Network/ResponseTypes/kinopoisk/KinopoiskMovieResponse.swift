//
//  KinopoiskMovieResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

struct KinopoiskMovieResponse: KinopoiskMovieResponseProtocol {
    var id: Int
    var name: String?
    var alternativeName: String?
    var enName: String?
    var type: String?
    var year: Int?
    var description: String?
    var shortDescription: String?
    var slogan: String?
    var status: String?
    var movieLength: Int?
    var poster: KinopoiskCoverResponse?
    var backdrop: KinopoiskCoverResponse?
    var genres: [KinopoiskGenreResponse]?
    var countries: [KinopoiskCountryResponse]?
    var persons: [KinopoiskPersonResponse]?
    var rating: KinopoiskRatingResponse?
    var similarMovies: [KinopoiskMovieResponse]?
}

struct KinopoiskCoverResponse: KinopoiskCoverResponseProtocol {
    var url: String?
    var previewUrl: String?
}

struct KinopoiskGenreResponse: KinopoiskGenreResponseProtocol {
    let name: String
}

struct KinopoiskCountryResponse: KinopoiskCountryResponseProtocol {
    let name: String
}

struct KinopoiskRatingResponse: KinopoiskRatingResponseProtocol {
    var kp: Double?
}
