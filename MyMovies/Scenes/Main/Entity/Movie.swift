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
        return productionCountrues
    }
    var poster: CoverProtocol? {
        return moviePoster
    }
    var backdrop: CoverProtocol? {
        return movieBackdrop
    }

    private let movieGenres: [Genre]
    private let productionCountrues: [ProductionCountry]
    private let moviePoster: Cover? // TMDB: poster_path / Kinopoisk: poster.url
    private let movieBackdrop: Cover? // TMDB: backdrop_path / Kinopoisk: backdrop.url

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
        poster: Cover?,
        backdrop: Cover?
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
        self.productionCountrues = countries
        self.moviePoster = poster
        self.movieBackdrop = backdrop
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
    }
}
