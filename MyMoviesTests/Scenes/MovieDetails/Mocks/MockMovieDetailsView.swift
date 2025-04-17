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
    
    var didCallShowDetailedMovieWith: MovieDetailsViewModelProtocol?
    var didCallShowMovieReviewsWith: [ReviewViewModelProtocol]?
    var didCallShowSimilarMoviesWith: [BriefMovieListItemViewModelProtocol]?
    var didCallShowErrorWith: String?
    
    // MARK: - MovieDetailsViewProtocol
    func showDetailedMovie(_ movie: MovieDetailsViewModelProtocol) {
        didCallShowDetailedMovie = true
        didCallShowDetailedMovieWith = movie
    }
    
    func showMovieReviews(_ reviews: [ReviewViewModelProtocol]) {
        didCallShowMovieReviews = true
        didCallShowMovieReviewsWith = reviews
    }
    
    func showSimilarMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowSimilarMovies = true
        didCallShowSimilarMoviesWith = movies
    }
    
    func showError(with message: String) {
        didCallShowError = true
        didCallShowErrorWith = message
    }
}
