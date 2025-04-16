//
//  MainInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainInteractorProtocol: AnyObject {
    var presenter: MainInteractorOutputProtocol? { get set }

    func fetchUserProfile()
    func fetchMovieGenres()
    func fetchMovies(with type: MovieListType)
    func fetchMoviesByGenre(_ genre: GenreProtocol, listType: MovieListType)
}

protocol PrefetchInteractorProtocol: AnyObject {
    func prefetchData()
}

protocol MainInteractorOutputProtocol: AnyObject, UserProfileObserverDelegate {
    func didFetchUserProfile(_ profile: UserProfileProtocol)
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchMovies(_ movies: [MovieProtocol], for type: MovieListType)
//    func didFetchUpcomingMovies(_ movies: [MovieProtocol])
//    func didFetchPopularMovies(_ movies: [MovieProtocol])
//    func didFetchTopRatedMovies(_ movies: [MovieProtocol])
//    func didFetchTheHighestGrossingMovies(_ movies: [MovieProtocol])

    func didBeginProfileUpdate()
    func didLogOut()
    func didFailToFetchData(with error: Error)
}
