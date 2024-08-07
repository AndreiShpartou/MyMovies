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
    func fetchMovieCategories()
    func fetchTopMovies()
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchMovieLists(_ movieLists: [MovieList])
    func didFetchMovieCategories(_ movieCategories: [MovieCategory])
    func didFetchTopMovies(_ movies: [Movie])
    func didFailToFetchData(with error: Error)
}
