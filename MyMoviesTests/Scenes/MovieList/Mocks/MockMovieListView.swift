//
//  MockMovieListView.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockView
final class MockMovieListView: UIView, MovieListViewProtocol {
    weak var delegate: MovieListViewInteractionDelegate?

    var didCallShowMovieGenres = false
    var didCallShowMovieList = false
    var didCallShowError = false
    var didCallSetLoadingIndicator = false

    var didCallShowMovieGenresWith: [GenreViewModelProtocol]?
    var didCallShowMovieListWith: [MovieListItemViewModelProtocol]?
    var didCallSetLoadingIndicatorWith: Bool?
    var didCallShowErrorWith: String?

    // MARK: - MovieListViewProtocol
    func showMovieGenres(_ genres: [GenreViewModelProtocol]) {
        didCallShowMovieGenres = true
        didCallShowMovieGenresWith = genres
    }

    func showMovieList(_ movies: [MovieListItemViewModelProtocol]) {
        didCallShowMovieList = true
        didCallShowMovieListWith = movies
    }

    func setLoadingIndicator(isVisible: Bool) {
        didCallSetLoadingIndicator = true
        didCallSetLoadingIndicatorWith = isVisible
    }

    func showError(with message: String) {
        didCallShowError = true
        didCallShowErrorWith = message
    }
}
