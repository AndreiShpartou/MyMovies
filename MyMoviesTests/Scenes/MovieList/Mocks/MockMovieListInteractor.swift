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
    
    var movies: [MockMovie]?
    var genres: [MockMovie.Genre]?

    // MARK: - MovieListInteractorProtocol
    func fetchMovieGenres(type: MovieListType) {
        didCallFetchMovieGenres = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter?.didFetchMovieGenres(self.genres!)
        }
    }

    func fetchMovieList(type: MovieListType) {
        didCallFetchMovieList = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter?.didFetchMovieList(self.movies!)
        }
    }

    func fetchMovieListWithGenresFiltering(genre: GenreProtocol) {
        didCallFetchMovieListWithGenresFiltering = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter?.didFetchMovieList(self.movies!)
        }
    }
}
