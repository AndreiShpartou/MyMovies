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
    var poster: KinopoiskCoverResponseProtocol? {
        moviePoster
    }
    var backdrop: KinopoiskCoverResponseProtocol? {
        return movieBackdrop
    }
    var genres: [KinopoiskGenreResponseProtocol]? {
        return movieGenres
    }
    var countries: [KinopoiskCountryResponseProtocol] {
        return movieCountries
    }
    var persons: [KinopoiskPersonResponseProtocol]? {
        return moviePersons
    }
    var rating: KinopoiskRatingResponseProtocol? {
        return movieRating
    }

    private let moviePoster: KinopoiskMovieResponse.Cover?
    private let movieBackdrop: KinopoiskMovieResponse.Cover?
    private let movieGenres: [KinopoiskMovieResponse.Genre]?
    private let movieCountries: [KinopoiskMovieResponse.Country]
    private let moviePersons: [KinopoiskMovieResponse.Person]?
    private let movieRating: KinopoiskMovieResponse.Rating?

    struct Cover: KinopoiskCoverResponseProtocol {
        var url: String?
        var previewUrl: String?
    }

    struct Genre: KinopoiskGenreResponseProtocol {
        let name: String
    }

    struct Country: KinopoiskCountryResponseProtocol {
        let name: String
    }

    struct Rating: KinopoiskRatingResponseProtocol {
        var kp: Double?
    }

    struct Person: KinopoiskPersonResponseProtocol {
        let id: Int?
        var photo: String?
        let name: String?
        var enName: String?
        var description: String?
        var profession: String?
        var enProfession: String?
    }

    enum CodingKeys: String, CodingKey {
        case id, name, alternativeName, enName, type, year, description, shortDescription, movieLength, status
        case moviePoster = "poster"
        case movieBackdrop = "backdrop"
        case movieGenres = "genres"
        case movieRating = "rating"
        case movieCountries = "countries"
        case moviePersons = "persons"
    }
}
