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

    var didCallFetchMoviesForType: [MovieListType: Bool] = [:]
    var didCallFetchMovieGenres: Bool = false
    var didCallFetchUserProfile: Bool = false
    
    var movies: [MockMovie]?
    var movieGenres: [MockMovie.Genre]?
    var userProfile: UserProfile?

    // MARK: - Init
    init(presenter: MainInteractorOutputProtocol? = nil) {
        self.presenter = presenter
    }
    
    // MARK: - MainInteractorProtocol
    func fetchMovieGenres() {
        didCallFetchMovieGenres = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter?.didFetchMovieGenres(self.movieGenres!)
        }
    }

    func fetchMovies(with type: MovieListType) {
        didCallFetchMoviesForType[type] = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter?.didFetchMovies(self.movies!, for: type)
        }
    }
    
    func fetchMoviesByGenre(_ genre: GenreProtocol, listType: MovieListType) {
        didCallFetchMoviesForType[listType] = true
    }

    func fetchUserProfile() {
        didCallFetchUserProfile = true
        presenter?.didFetchUserProfile(userProfile!)
    }
}
