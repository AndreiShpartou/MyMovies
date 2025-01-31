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
    func fetchTopRatedMovies()
    func fetchTheHighestGrossingMovies()
    func fetchPopularMoviesWithGenresFiltering(genre: GenreProtocol)
    func fetchTopRatedMoviesWithGenresFiltering(genre: GenreProtocol)
    func fetchTheHighestGrossingMoviesWithGenresFiltering(genre: GenreProtocol)
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchUpcomingMovies(_ movies: [MovieProtocol])
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchPopularMovies(_ movies: [MovieProtocol])
    func didFetchTopRatedMovies(_ movies: [MovieProtocol])
    func didFetchTheHighestGrossingMovies(_ movies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
}
