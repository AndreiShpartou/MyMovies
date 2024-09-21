//
//  UpcomingMovieViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/09/2024.
//

import Foundation

protocol UpcomingMovieViewModelProtocol {
    var id: Int { get }
    var title: String { get }
    var shortDescription: String? { get }
    var posterURL: URL? { get }
    var backdropURL: URL? { get }
}
