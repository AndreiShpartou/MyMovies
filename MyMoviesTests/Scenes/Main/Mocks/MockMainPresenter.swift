//
//  MockMainPresenter.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockPresenter
final class MockMainPresenter: MainInteractorOutputProtocol {
    var didCallDidFetchUpcomingMoviesCallBack: (([MovieProtocol]) -> Void)?
    var didCallDidFetchMovieGenresCallBack: (([GenreProtocol]) -> Void)?
    var didCallDidFetchPopularMoviesCallBack: (([MovieProtocol]) -> Void)?
    var didCallDidFetchTopRatedMoviesCallBack: (([MovieProtocol]) -> Void)?
    var didCallDidFetchTheHighestGrossingMoviesCallBack: (([MovieProtocol]) -> Void)?
    var didCallDidFetchUserProfileCallBack: ((UserProfileProtocol) -> Void)?
    var didCallDidBefinProfileUpdate: Bool = false
    var didCallDidLogOut: Bool = false
    var didCallDidFailToFetchDataCallBack: ((Error) -> Void)?
    
    // MARK: - MainInteractorOutputProtocol
    func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        didCallDidFetchUpcomingMoviesCallBack?(movies)
    }
    
    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        didCallDidFetchMovieGenresCallBack?(genres)
    }
    
    func didFetchPopularMovies(_ movies: [MovieProtocol]) {
        didCallDidFetchPopularMoviesCallBack?(movies)
    }
    
    func didFetchTopRatedMovies(_ movies: [MovieProtocol]) {
        didCallDidFetchTopRatedMoviesCallBack?(movies)
    }
    
    func didFetchTheHighestGrossingMovies(_ movies: [MovieProtocol]) {
        didCallDidFetchTheHighestGrossingMoviesCallBack?(movies)
    }
}

extension MockMainPresenter: UserProfileObserverDelegate {
    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        didCallDidFetchUserProfileCallBack?(profile)
    }
    
    func didBeginProfileUpdate() {
        didCallDidBefinProfileUpdate = true
    }
    func didLogOut() {
        didCallDidLogOut = true
    }
    func didFailToFetchData(with error: Error) {
        didCallDidFailToFetchDataCallBack?(error)
    }
}
