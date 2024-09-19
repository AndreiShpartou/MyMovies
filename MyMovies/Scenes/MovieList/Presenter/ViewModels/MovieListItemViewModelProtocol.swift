//
//  MovieListItemViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 18/09/2024.
//

import Foundation

protocol MovieListItemViewModelProtocol {
    var title: String { get }
    var voteAverage: String { get }
    var genre: String { get }
    var countries: [String] { get }
    var releaseYear: String { get }
    var runtime: String { get }
    var posterURL: URL? { get }
}
