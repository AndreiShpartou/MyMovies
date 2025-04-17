//
//  MockMovieListInteractor.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockInteractor
final class MockMovieListInteractor: MovieListInteractorProtocol {
    weak var presenter: MovieListInteractorOutputProtocol?
    
    var didCallFetchMovieGenres = false
    var didCallFetchMovieList = false
    var didCallFetchMovieListWithGenresFiltering = false
    
    // MARK: - MovieListInteractorProtocol
    func fetchMovieGenres(type: MovieListType) {
        didCallFetchMovieGenres = true
    }

    func fetchMovieList(type: MovieListType) {
        didCallFetchMovieList = true
    }

    func fetchMovieListWithGenresFiltering(genre: GenreProtocol) {
        didCallFetchMovieListWithGenresFiltering = true
    }
}
