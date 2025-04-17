//
//  MockMovieDetailsInteractor.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockInteractor
final class MockMovieDetailsInteractor: MovieDetailsInteractorProtocol {
    weak var presenter: MovieDetailsInteractorOutputProtocol?
    
    var didCallFetchMovie = false
    var didCallFetchReviews = false
    var didCallFetchSimilarMovies = false
    var didCallFetchIsMovieInList = false
    var didCallToggleFavouriteStatus = false

    // MARK: - MovieDetailsInteractorProtocol
    func fetchMovie() {
        didCallFetchMovie = true
    }
    
    func fetchReviews() {
        didCallFetchReviews = true
    }
    
    func fetchSimilarMovies() {
        didCallFetchSimilarMovies = true
    }
    
    func fetchIsMovieInList(listType: MovieListType) {
        didCallFetchIsMovieInList = true
    }
    
    func toggleFavouriteStatus(isFavourite: Bool) {
        didCallToggleFavouriteStatus = true
    }
}
