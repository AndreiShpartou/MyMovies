//
//  SearchInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol SearchInteractorProtocol: AnyObject {
    var presenter: SearchInteractorOutputProtocol? { get set }

    func fetchInitialData()
    func fetchUpcomingMoviesWithGenresFiltering(genre: GenreProtocol)
    func performSearch(with query: String)
}

protocol SearchInteractorOutputProtocol: AnyObject {
    func didFetchGenres(_ genres: [GenreProtocol])
    func didFetchUpcomingMovies(_ movies: [MovieProtocol])
    func didFetchRecentlySearchedMovies(_ movies: [MovieProtocol])
    func didFetchMoviesSearchResults(_ movies: [MovieProtocol])
    func didFetchPersonsSearchResults(_ persons: [PersonProtocol])
    func didFailToFetchData(with error: Error)
}
