//
//  MainInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainInteractorProtocol: AnyObject {
    var presenter: MainInteractorOutputProtocol? { get set }

    func fetchUpcomingMovies()
    func fetchMovieGenres()
    func fetchPopularMovies()
    func fetchPopularMoviesWithGenresFiltering(genre: GenreProtocol)
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchUpcomingMovies(_ movies: [MovieProtocol])
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchPopularMovies(_ movies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
}
