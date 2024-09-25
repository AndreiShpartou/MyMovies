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
    var description: String { get }
    var voteAverage: String { get }
    var genre: String { get }
    var releaseYear: String { get }
    var runtime: String { get }
    var backdropURL: URL? { get }
    var posterURL: URL? { get }
}
