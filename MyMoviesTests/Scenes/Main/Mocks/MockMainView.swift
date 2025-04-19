//
//  MockMainView.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import UIKit
@testable import MyMovies

// MARK: - MockView
final class MockMainView: UIView, MainViewProtocol {
    weak var delegate: MainViewDelegate?
    
    var didCallShowUpcomingMoviesCallBack: (([UpcomingMovieViewModelProtocol]) -> Void)?
    var didCallScrollToUpcomingMovieItem: Bool = false
    var didCallShowPopularMoviesCallBack: (([BriefMovieListItemViewModelProtocol]) -> Void)?
    var didCallShowTopRatedMoviesCallBack: (([BriefMovieListItemViewModelProtocol]) -> Void)?
    var didCallShowTheHighestGrossingMoviesCallBack: (([BriefMovieListItemViewModelProtocol]) -> Void)?
    var didCallShowMovieGenresCallBack: (([GenreViewModelProtocol]) -> Void)?
    var didCallShowUserProfile: Bool = false
    var didCallDidLogOut: Bool = false
    var didCallShowError: Bool = false

    var capturedUserProfile: UserProfileViewModelProtocol?
    var capturedError: String?
    var loadingStates: [MainAppSection: Bool] = [
        .userProfile: false,
        .upcomingMovies: false,
        .popularMovies: false,
        .topRatedMovies: false,
        .theHighestGrossingMovies: false
    ]
    
    // MARK: - MainViewProtocol
    func showUpcomingMovies(_ movies: [UpcomingMovieViewModelProtocol]) {
        didCallShowUpcomingMoviesCallBack?(movies)
    }
    
    func scrollToUpcomingMovieItem(_ index: Int) {
        didCallScrollToUpcomingMovieItem = true
    }
    
    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowPopularMoviesCallBack?(movies)
    }
    
    func showTopRatedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowTopRatedMoviesCallBack?(movies)
    }
    
    func showTheHighestGrossingMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowTheHighestGrossingMoviesCallBack?(movies)
    }
    
    func showMovieGenres(_ genres: [GenreViewModelProtocol]) {
        didCallShowMovieGenresCallBack?(genres)
    }
    
    func showUserProfile(_ user: UserProfileViewModelProtocol) {
        didCallShowUserProfile = true
        capturedUserProfile = user
    }
    
    func didLogOut() {
        didCallDidLogOut = true
    }
    
    func setLoadingIndicator(for section: MainAppSection, isVisible: Bool) {
        loadingStates[section] = isVisible
    }
    
    func showError(with messsage: String) {
        didCallShowError = true
        capturedError = messsage
    }
}
