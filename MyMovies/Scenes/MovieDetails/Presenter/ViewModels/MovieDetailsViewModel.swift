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
    let description: String
    let voteAverage: String
    let genre: String
    let releaseYear: String
    let runtime: String
    var backdropURL: URL?
    var posterURL: URL?
}
