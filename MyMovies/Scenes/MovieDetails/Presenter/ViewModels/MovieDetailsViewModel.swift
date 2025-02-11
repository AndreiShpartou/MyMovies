//
//  MovieDetailsViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 25/09/2024.
//

import Foundation

struct MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    let id: Int
    let title: String
    var alternativeTitle: String?
    let description: String
    let voteAverage: String
    let genre: String
    let releaseYear: String
    let runtime: String
    var backdropURL: URL?
    var posterURL: URL?
    var countries: [CountryViewModelProtocol] = []
    var persons: [PersonViewModelProtocol] = []
    var genres: [GenreViewModelProtocol] = []

    init(
        id: Int,
        title: String,
        alternativeTitle: String?,
        description: String,
        voteAverage: String,
        genre: String,
        releaseYear: String,
        runtime: String,
        countries: [CountryViewModelProtocol],
        persons: [PersonViewModelProtocol],
        genres: [GenreViewModelProtocol],
        backdropURL: URL? = nil,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.alternativeTitle = alternativeTitle
        self.description = description
        self.voteAverage = voteAverage
        self.genre = genre
        self.releaseYear = releaseYear
        self.runtime = runtime
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.countries = countries
        self.persons = persons
        self.genres = genres
    }
}

struct CountryViewModel: CountryViewModelProtocol {
    var name: String
}

struct PersonViewModel: PersonViewModelProtocol {
    var id: Int
    var photo: URL?
    var name: String
    var profession: String?
}
