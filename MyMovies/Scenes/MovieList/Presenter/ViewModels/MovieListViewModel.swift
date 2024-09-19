//
//  MovieListViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 18/09/2024.
//

import Foundation

struct MovieListViewModel: MovieListViewModelProtocol {
    let title: String
    let voteAverage: String
    let genre: String
    let countries: [String]
    let releaseYear: String
    let runtime: String
    var posterURL: URL?

    init(title: String, voteAverage: String, genre: String, countries: [String], posterURL: URL? = nil, releaseYear: String, runtime: String) {
        self.title = title
        self.voteAverage = voteAverage
        self.genre = genre
        self.countries = countries
        self.posterURL = posterURL
        self.releaseYear = releaseYear
        self.runtime = runtime
    }
}
