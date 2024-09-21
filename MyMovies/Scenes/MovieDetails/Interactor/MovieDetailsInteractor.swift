//
//  MovieDetailsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    weak var presenter: MovieDetailsInteractorOutputProtocol?

    private let movie: MovieProtocol

    // MARK: - Init
    init(movie: MovieProtocol) {
        self.movie = movie
    }
}
