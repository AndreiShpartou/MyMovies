//
//  MainInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainInteractorProtocol: AnyObject {
    var presenter: MainInteractorOutputProtocol? { get set }

    func fetchMovieGenres()
    func fetchMovies(with type: MovieListType)
    func fetchMoviesByGenre(_ genre: GenreProtocol, listType: MovieListType)
    func fetchUserProfile()
}

protocol PrefetchInteractorProtocol: AnyObject {
    func prefetchData()
}

protocol MainInteractorOutputProtocol: AnyObject, UserProfileObserverDelegate {
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchMovies(_ movies: [MovieProtocol], for type: MovieListType)
    func didFetchUserProfile(_ profile: UserProfileProtocol)
    func didBeginProfileUpdate()
    func didLogOut()
    func didFailToFetchData(with error: Error)
}
