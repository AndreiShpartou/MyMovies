//
//  MockMovie.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 16/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockMovie
struct MockMovie: MovieProtocol {
    let id: Int // id
    let title: String // TMDB: title, Kinopoisk: name
    let alternativeTitle: String? // TMDB: original_title, Kinopoisk: alternativeName
    let description: String? // TMDB: overview, Kinopoisk: description
    let shortDescription: String? // TMDB: tagline, Kinopoisk: shortDescription
    let status: String?
    let releaseYear: String? // TMDB: release_date -> map, Kinopoisk: year -> map)
    let runtime: String?  // TMDB: runtime, Kinopoisk: movieLength
    let voteAverage: Double? //  TMDB: vote_average, Kinopoisk: rating.kp
    var genres: [Genre]
    var countries: [ProductionCountry]
    var persons: [Person]
    var poster: Cover?
    var backdrop: Cover?
    var similarMovies: [Movie]?

    init(
        id: Int = 1,
        title: String = "MockMovie",
        alternativeTitle: String? = "",
        description: String? = "",
        shortDescription: String? = "",
        status: String? = "",
        releaseYear: String? = "",
        runtime: String? = "",
        voteAverage: Double? = nil,
        genres: [Genre] = [],
        countries: [ProductionCountry] = [],
        persons: [Person] = [],
        poster: Cover? = nil,
        backdrop: Cover? = nil,
        similarMovies: [Movie]? = nil
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
        self.genres = genres
        self.countries = countries
        self.persons = persons
        self.poster = poster
        self.backdrop = backdrop
        self.similarMovies = similarMovies
    }
}

struct MockGenre: GenreProtocol {
    let id: Int? // TMDB
    var name: String? {
        return rawName?.capitalizingFirstLetter()
    }

    private(set) var rawName: String?

    init(id: Int? = 0, name: String? = "MockGenre") {
        self.id = id
        self.rawName = name
    }
}

struct MockCover: CoverProtocol {
    let url: String?
    let previewUrl: String?
}

struct MockProductionCountry: CountryProtocol {
    let name: String
    let fullName: String
}

struct MockPerson: PersonProtocol {
    var id: Int = 0
    var photo: String?
    var name: String = "MockPerson"
    var profession: String?
    var popularity: Float?
}
