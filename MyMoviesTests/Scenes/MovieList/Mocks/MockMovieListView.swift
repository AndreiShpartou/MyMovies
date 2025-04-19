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

    var didCallShowMovieGenresCallBack: (([GenreViewModelProtocol]) -> Void)?
    var didCallShowMovieListCallBack: (([MovieListItemViewModelProtocol]) -> Void)?
    var didCallShowError = false
    var didCallSetLoadingIndicator = false

    var capturedIndicatorState: Bool?
    var capturedError: String?


    // MARK: - MovieListViewProtocol
    func showMovieGenres(_ genres: [GenreViewModelProtocol]) {
        didCallShowMovieGenresCallBack?(genres)
    }

    func showMovieList(_ movies: [MovieListItemViewModelProtocol]) {
        didCallShowMovieListCallBack?(movies)
    }

    func setLoadingIndicator(isVisible: Bool) {
        didCallSetLoadingIndicator = true
        capturedIndicatorState = isVisible
    }

    func showError(with message: String) {
        didCallShowError = true
        capturedError = message
    }
}
