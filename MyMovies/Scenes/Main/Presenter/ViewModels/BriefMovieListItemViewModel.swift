//
//  BriefMovieListItemViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/09/2024.
//

import Foundation

struct BriefMovieListItemViewModel: BriefMovieListItemViewModelProtocol {
    let title: String
    var posterURL: URL?
    let genre: String
    let voteAverage: String
}
