//
//  Movie.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/07/2024.
//

import Foundation

struct Movie: MovieProtocol {
    let id: Int // id
    let title: String // TMDB: title, Kinopoisk: name
    let alternativeTitle: String? // TMDB: original_title, Kinopoisk: alternativeName
    let description: String? // TMDB: overview, Kinopoisk: description
    let shortDescription: String? // TMDB: tagline, Kinopoisk: shortDescription
    let status: String?
    let releaseYear: String? // TMDB: release_date -> map, Kinopoisk: year -> map)
    let runtime: String?  // TMDB: runtime, Kinopoisk: movieLength
    let voteAverage: Double? //  TMDB: vote_average, Kinopoisk: rating.kp
    var genres: [GenreProtocol] {
        return movieGenres
    }
    var countries: [CountryProtocol] {
        return productionCountries
    }
    var persons: [PersonProtocol] {
        return moviePersons
    }
    var poster: CoverProtocol? {
        return moviePoster
    }
    var backdrop: CoverProtocol? {
        return movieBackdrop
    }
    var similarMovies: [MovieProtocol]? {
        return arrayofSimilarMovies
    }

    private let movieGenres: [Genre]
    private let productionCountries: [ProductionCountry]
    private let moviePersons: [Person]
    private let moviePoster: Cover? // TMDB: poster_path / Kinopoisk: poster.url
    private let movieBackdrop: Cover? // TMDB: backdrop_path / Kinopoisk: backdrop.url
    private let arrayofSimilarMovies: [Movie]? // Kinopoisk: similarMovies // TMDB: distinct endpoint

    init(
        id: Int,
        title: String,
        alternativeTitle: String?,
        description: String?,
        shortDescription: String?,
        status: String?,
        releaseYear: String?,
        runtime: String?,
        voteAverage: Double?,
        genres: [Genre],
        countries: [ProductionCountry],
        persons: [Person],
        poster: Cover?,
        backdrop: Cover?,
        similarMovies: [Movie]?
    ) {
        self.id = id
        self.title = title
        self.alternativeTitle = alternativeTitle
        self.description = description
        self.shortDescription = shortDescription
        self.status = status
        self.releaseYear = releaseYear
        self.runtime = runtime
        self.voteAverage = voteAverage
        self.movieGenres = genres
        self.productionCountries = countries
        self.moviePersons = persons
        self.moviePoster = poster
        self.movieBackdrop = backdrop
        self.arrayofSimilarMovies = similarMovies
    }

    struct Genre: GenreProtocol {
        let id: Int? // TMDB
        var name: String? {
            return rawName?.capitalizingFirstLetter()
        }

        private(set) var rawName: String?

        init(id: Int? = nil, name: String?) {
            self.id = id
            self.rawName = name
        }
    }

    struct Cover: CoverProtocol {
        let url: String?
        let previewUrl: String?
    }

    struct ProductionCountry: CountryProtocol {
        let name: String
        let fullName: String
    }

    struct Person: PersonProtocol {
        var id: Int
        var photo: String?
        var name: String
        var profession: String?
        var popularity: Float?
    }
}
