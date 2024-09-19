//
//  UpcomingMovieViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/09/2024.
//

import Foundation

struct UpcomingMovieViewModel: UpcomingMovieViewModelProtocol {
    let title: String
    let shortDescription: String?
    var posterURL: URL?
    var backdropURL: URL?
}
