//
//  PersonDetailsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

protocol PersonDetailsInteractorProtocol: AnyObject {
    var presenter: PersonDetailsInteractorOutputProtocol? { get set }

    func fetchPersonDetails()
    func fetchMovieGenres()
    func fetchPersonRelatedMovies()
    func fetchPersonRelatedMoviesWithGenresFiltering(for genre: GenreProtocol)
}

protocol PersonDetailsInteractorOutputProtocol: AnyObject {
    func didFetchPersonDetails(_ person: PersonDetailed)
    func didFetchMovieGenres(_ genres: [GenreProtocol])
    func didFetchPersonRelatedMovies(_ movies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
}
