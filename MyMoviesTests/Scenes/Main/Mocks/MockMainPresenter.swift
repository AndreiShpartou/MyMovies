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
    var didCallDidFetchMovieGenresCallBack: (([GenreProtocol]) -> Void)?
    var didCallDidFetchMoviesCallBack: (([MovieProtocol]) -> Void)?
    var didCallDidFetchUserProfileCallBack: ((UserProfileProtocol) -> Void)?
    var didCallDidBeginProfileUpdate: Bool = false
    var didCallDidLogOut: Bool = false
    var didCallDidFailToFetchDataCallBack: ((Error) -> Void)?
    
    // MARK: - MainInteractorOutputProtocol
    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        didCallDidFetchMovieGenresCallBack?(genres)
    }
    
    func didFetchMovies(_ movies: [MovieProtocol], for type: MovieListType) {
        didCallDidFetchMoviesCallBack?(movies)
    }
}

extension MockMainPresenter: UserProfileObserverDelegate {
    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        didCallDidFetchUserProfileCallBack?(profile)
    }
    
    func didBeginProfileUpdate() {
        didCallDidBeginProfileUpdate = true
    }
    func didLogOut() {
        didCallDidLogOut = true
    }
    func didFailToFetchData(with error: Error) {
        didCallDidFailToFetchDataCallBack?(error)
    }
}
