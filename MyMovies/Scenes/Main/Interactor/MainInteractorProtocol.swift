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
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchMovieLists(_ movieLists: MovieLists)
    func didFetchMovieCategories(_ movieCategories: [MovieCategory])
    func didFailToFetchData(with error: Error)
}
