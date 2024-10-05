//
//  BriefMovieListItemViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/09/2024.
//

import Foundation

protocol BriefMovieListItemViewModelProtocol {
    var id: Int { get }
    var title: String { get }
    var posterURL: URL? { get }
    var genre: String { get }
    var voteAverage: String { get }
}
