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
    func performSearch(with query: String)
}

protocol SearchInteractorOutputProtocol: AnyObject {
    func didFetchGenres(_ genres: [GenreProtocol])
    func didFetchUpcomingMovie(_ movie: MovieProtocol)
    func didFetchRecentlySearchedMovies(_ movies: [MovieProtocol])
    func didFetchSearchResults(_ movies: [MovieProtocol])
    func didFetchPersonResults(_ persons: [PersonProtocol], relatedMovies: [MovieProtocol])
    func didFailToFetchData(with error: Error)
}
