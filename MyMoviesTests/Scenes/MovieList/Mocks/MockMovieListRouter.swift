//
//  MockMovieListRouter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockRouter
final class MockMovieListRouter: MovieListRouterProtocol {
    var viewController: UIViewController?

    var didCallNavigateToMovieDetails = false
    var didCallNavigateToMovieDetailsWith: MovieProtocol?

    // MARK: - MovieListRouterProtocol
    func navigateToMovieDetails(with movie: MovieProtocol) {
        didCallNavigateToMovieDetails = true
        didCallNavigateToMovieDetailsWith = movie
    }
}
