//
//  MockMainInteractor.swift
//  MyMoviesTests
//
//  Created by Andrei Shpartou on 15/04/2025.
//

import Foundation
@testable import MyMovies

// MARK: - MockInteractor
final class MockMainInteractor: MainInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol?
    
    var didCallFetchUserProfile: Bool = false
    var didCallFetchUpcomingMovies: Bool = false
    var didCallFetchMovieGenres: Bool = false
    var didCallFetchPopularMovies: Bool = false
    var didCallFetchTopRatedMovies: Bool = false
    var didCallFetchTheHighestGrossingMovies: Bool = false
    var didCallFetchPopularMoviesWithGenreFiltering: Bool = false
    var didCallFetchTopRatedMoviesWithGenreFiltering: Bool = false
    var didCallFetchTheHighestGrossingMoviesWithGenreFiltering: Bool = false

    // MARK: - Init
    init(presenter: MainInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }
    
    
    // MARK: - MainInteractorProtocol
    func fetchUserProfile() {
        didCallFetchUserProfile = true
    }
    
    func fetchUpcomingMovies() {
        didCallFetchUpcomingMovies = true
    }
    
    func fetchMovieGenres() {
        didCallFetchMovieGenres = true
    }
    
    func fetchPopularMovies() {
        didCallFetchPopularMovies = true
    }
    
    func fetchTopRatedMovies() {
        didCallFetchTopRatedMovies = true
    }
    
    func fetchTheHighestGrossingMovies() {
        didCallFetchTheHighestGrossingMovies = true
    }
    
    func fetchPopularMoviesWithGenresFiltering(genre: GenreProtocol) {
        didCallFetchPopularMoviesWithGenreFiltering = true
    }
    
    func fetchTopRatedMoviesWithGenresFiltering(genre: GenreProtocol) {
        didCallFetchTopRatedMoviesWithGenreFiltering = true
    }
    
    func fetchTheHighestGrossingMoviesWithGenresFiltering(genre: GenreProtocol) {
        didCallFetchTheHighestGrossingMoviesWithGenreFiltering = true
    }
}
