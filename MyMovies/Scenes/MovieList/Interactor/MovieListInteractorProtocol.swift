//
//  MovieListInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MovieListInteractorProtocol {
    var presenter: MovieListInteractorOutputProtocol? { get set }

    func fetchMovieGenres()
    func fetchMovieList(type: MovieListType)
    func fetchMovieListWithGenresFiltering(genre: GenreProtocol)
}

protocol MovieListInteractorOutputProtocol: AnyObject {
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchMovieList(_ movies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
}
