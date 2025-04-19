//
//  MockMovieDetailsView.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockView
final class MockMovieDetailsView: UIView, MovieDetailsViewProtocol {
    weak var delegate: MovieDetailsViewDelegate?

    var didCallShowDetailedMovie = false
    var didCallShowMovieReviews = false
    var didCallShowSimilarMovies = false
    var didCallShowError = false

    var capturedMovie: MovieDetailsViewModelProtocol?
    var capturedReviews: [ReviewViewModelProtocol]?
    var capturedSimilarMovies: [BriefMovieListItemViewModelProtocol]?
    var capturedError: String?
    
    // MARK: - MovieDetailsViewProtocol
    func showDetailedMovie(_ movie: MovieDetailsViewModelProtocol) {
        didCallShowDetailedMovie = true
        capturedMovie = movie
    }
    
    func showMovieReviews(_ reviews: [ReviewViewModelProtocol]) {
        didCallShowMovieReviews = true
        capturedReviews = reviews
    }
    
    func showSimilarMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowSimilarMovies = true
        capturedSimilarMovies = movies
    }
    
    func showError(with message: String) {
        didCallShowError = true
        capturedError = message
    }
}
