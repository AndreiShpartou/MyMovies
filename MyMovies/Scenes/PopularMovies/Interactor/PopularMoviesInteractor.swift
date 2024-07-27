//
//  PopularMoviesInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol PopularMoviesInteractorProtocol {
}

class PopularMoviesInteractor: PopularMoviesInteractorProtocol {
    weak var presenter: PopularMoviesPresenterProtocol?
}
