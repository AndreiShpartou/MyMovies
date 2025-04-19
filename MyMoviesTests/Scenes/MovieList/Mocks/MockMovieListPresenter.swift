//
//  MockMovieListPresenter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockPresenter
final class MockMovieListPresenter: MovieListInteractorOutputProtocol {
    var didCallDidFetchMovieGenresCallBack: (([GenreProtocol]) -> Void)?
    var didCallDidFetchMovieListCallBack: (([MovieProtocol]) -> Void)?
    var didCallDidFailToFetchDataCallBack: ((Error) -> Void)?
    
    // MARK: - MovieListInteractorOutputProtocol
    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        didCallDidFetchMovieGenresCallBack?(genres)
    }

    func didFetchMovieList(_ movies: [MovieProtocol]) {
        didCallDidFetchMovieListCallBack?(movies)
    }

    func didFailToFetchData(with error: Error) {
        didCallDidFailToFetchDataCallBack?(error)
    }
}
