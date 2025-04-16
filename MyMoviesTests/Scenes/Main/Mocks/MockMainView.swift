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
    
    var didCallShowUpcomingMovies: Bool = false
    var didCallScrollToUpcomingMovieItem: Bool = false
    var didCallShowPopularMovies: Bool = false
    var didCallShowTopRatedMovies: Bool = false
    var didCallShowTheHighestGrossingMovies: Bool = false
    var didCallShowMovieGenres: Bool = false
    var didCallShowUserProfile: Bool = false
    var didCallDidLogOut: Bool = false
    var didCallShowError: Bool = false
    
    var didCallShowUpcomingMoviesWith: [UpcomingMovieViewModelProtocol]?
    var didCallShowPopularMoviesWith: [BriefMovieListItemViewModelProtocol]?
    var didCallShowTopRatedMoviesWith: [BriefMovieListItemViewModelProtocol]?
    var didCallShowTheHighestGrossingMoviesWith: [BriefMovieListItemViewModelProtocol]?
    var didCallShowMovieGenresWith: [GenreViewModelProtocol]?
    var didCallShowUserProfileWith: UserProfileViewModelProtocol?
    var errorMessage: String?
    var loadingStates: [MainAppSection: Bool] = [
        .userProfile: false,
        .upcomingMovies: false,
        .popularMovies: false,
        .topRatedMovies: false,
        .theHighestGrossingMovies: false
    ]
    
    // MARK: - MainViewProtocol
    func showUpcomingMovies(_ movies: [UpcomingMovieViewModelProtocol]) {
        didCallShowUpcomingMovies = true
        didCallShowUpcomingMoviesWith = movies
    }
    
    func scrollToUpcomingMovieItem(_ index: Int) {
        didCallScrollToUpcomingMovieItem = true
    }
    
    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowPopularMovies = true
        didCallShowPopularMoviesWith = movies
    }
    
    func showTopRatedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowTopRatedMovies = true
        didCallShowTopRatedMoviesWith = movies
    }
    
    func showTheHighestGrossingMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        didCallShowTheHighestGrossingMovies = true
        didCallShowTheHighestGrossingMoviesWith = movies
    }
    
    func showMovieGenres(_ genres: [GenreViewModelProtocol]) {
        didCallShowMovieGenres = true
        didCallShowMovieGenresWith = genres
    }
    
    func showUserProfile(_ user: UserProfileViewModelProtocol) {
        didCallShowUserProfile = true
        didCallShowUserProfileWith = user
    }
    
    func didLogOut() {
        didCallDidLogOut = true
    }
    
    func setLoadingIndicator(for section: MainAppSection, isVisible: Bool) {
        loadingStates[section] = isVisible
    }
    
    func showError(with messsage: String) {
        didCallShowError = true
        errorMessage = messsage
    }
}
