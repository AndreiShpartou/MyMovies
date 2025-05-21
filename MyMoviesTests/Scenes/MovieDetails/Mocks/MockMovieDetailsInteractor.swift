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
    
    var movie: MockMovie?
    var reviews: [MovieReview]?
    var similarMovies: [MockMovie]?
    var isfavourite = false

    // MARK: - MovieDetailsInteractorProtocol
    func fetchMovie() {
        didCallFetchMovie = true
        presenter?.didFetchMovie(movie!)
    }
    
    func fetchReviews() {
        didCallFetchReviews = true
        presenter?.didFetchReviews(reviews!)
    }
    
    func fetchSimilarMovies() {
        didCallFetchSimilarMovies = true
        presenter?.didFetchSimilarMovies(similarMovies!)
    }
    
    func fetchIsMovieInList(listType: MovieListType) {
        didCallFetchIsMovieInList = true
        presenter?.didFetchIsMovieInList(true, listType: listType)
    }
    
    func toggleFavouriteStatus(isFavourite: Bool) {
        didCallToggleFavouriteStatus = true
        self.isfavourite = isFavourite
    }
}
