//
//  MovieDetailsViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 25/09/2024.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var id: Int { get }
    var title: String { get }
    var alternativeTitle: String? { get }
    var description: String { get }
    var voteAverage: String { get }
    var genre: String { get }
    var releaseYear: String { get }
    var runtime: String { get }
    var backdropURL: URL? { get }
    var posterURL: URL? { get }
    var countries: [CountryViewModelProtocol] { get }
    var persons: [PersonViewModelProtocol] { get }
    var genres: [GenreViewModelProtocol] { get }
}

protocol PersonViewModelProtocol {
    var id: Int { get }
    var photo: URL? { get }
    var name: String { get }
    var originalName: String? { get }
    var profession: String? { get }
}

protocol CountryViewModelProtocol {
    var name: String { get }
}
