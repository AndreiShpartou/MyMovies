//
//  MockMovieDetailsRouter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockRouter
final class MockMovieDetailsRouter: MovieDetailsRouterProtocol {
    weak var viewController: UIViewController?
    
    var didCallNavigateToMovieDetails = false
    var didCallNavigateToPersonDetails = false
    var didCallNavigateToMovieList = false
    var didCallNavigateToReviewDetails = false
    
    var capturedMovie: MovieProtocol?
    var capturedPersonID: Int?
    var capturedType: MovieListType?
    var capturedAuthor: String?
    var capturedText: String?
    var capturedTitle: String?
    
    // MARK: - MovieDetailsRouterProtocol
    func navigateToMovieDetails(with movie: MovieProtocol) {
        didCallNavigateToMovieDetails = true
        capturedMovie = movie
    }

    func navigateToPersonDetails(with personID: Int) {
        didCallNavigateToPersonDetails = true
        capturedPersonID = personID
    }

    func navigateToMovieList(type: MovieListType) {
        didCallNavigateToMovieList = true
        capturedType = type
    }

    func navigateToReviewDetails(with author: String?, and text: String?, title: String) {
        didCallNavigateToReviewDetails = true
        capturedAuthor = author
        capturedText = text
        capturedTitle = title
    }
}
