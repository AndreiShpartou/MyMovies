//
//  MockMovieDetailsPresenter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 17/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockPresenter
final class MockMovieDetailsPresenter: MovieDetailsInteractorOutputProtocol {
    var didCallFetchMovieCallBack: ((MovieProtocol) -> Void)?
    var didCallFetchReviewsCallBack: (([MovieReviewProtocol]) -> Void)?
    var didCallFetchSimilarMoviesCallBack: (([MovieProtocol]) -> Void)?
    var didCallFetchIsMovieInListCallBack: ((Bool, MovieListType) -> Void)?
    var didCallFetchErrorCallBack: ((Error) -> Void)?

    // MARK: - MovieDetailsInteractorOutputProtocol
    func didFetchMovie(_ movie: MovieProtocol) {
        didCallFetchMovieCallBack?(movie)
    }

    func didFetchReviews(_ reviews: [MovieReviewProtocol]) {
        didCallFetchReviewsCallBack?(reviews)
    }

    func didFetchSimilarMovies(_ movies: [MovieProtocol]) {
        didCallFetchSimilarMoviesCallBack?(movies)
    }

    func didFailToFetchData(with error: Error) {
        didCallFetchErrorCallBack?(error)
    }

    func didFetchIsMovieInList(_ isInList: Bool, listType: MovieListType) {
        didCallFetchIsMovieInListCallBack?(isInList, listType)
    }
}
