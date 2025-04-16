//
//  MockMainRouter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockRouter
final class MockMainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?
    
    var didCallNavigateToMovieDetails: Bool = false
    var didCallNavigateToMovieList: Bool = false
    var didCallNavigateToWishlist: Bool = false
    
    var capturedMovie: MovieProtocol?
    var capturedMovieListType: MovieListType?

    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - MainRouterProtocol
    func navigateToMovieDetails(with movie: MovieProtocol) {
        didCallNavigateToMovieDetails = true
        capturedMovie = movie
    }

    func navigateToMovieList(type: MovieListType) {
        didCallNavigateToMovieList = true
        capturedMovieListType = type
    }

    func navigateToWishlist() {
        didCallNavigateToWishlist = true
    }
}
