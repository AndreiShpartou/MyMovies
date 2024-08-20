//
//  MainInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol MainInteractorProtocol: AnyObject {
    var presenter: MainInteractorOutputProtocol? { get set }

    func fetchMovieLists()
    func fetchMovieGenres()
    func fetchTopMovies()
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchMovieLists(_ movieLists: [MovieList])
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchTopMovies(_ movies: [Movie])
    func didFailToFetchData(with error: Error)
}
