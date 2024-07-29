//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol MainInteractorProtocol: AnyObject {
    var presenter: MainPresenterProtocol? { get set }

    func fetchMovies()
    func fetchCategories()
}

class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainPresenterProtocol?

    func fetchMovies() {
        // Fetch movies from data source (e.g., API, database)
        // For now, return mock data
        let movies = [Movie(title: "Spider-Man", posterURL: "url", rating: 4.5, genre: "Action")]
        presenter?.didFetchMovies(movies)
    }

    func fetchCategories() {
        // Fetch categories from data source
        let categories = [Category(name: "All"), Category(name: "Comedy")]
        presenter?.didFetchCategories(categories)
    }
}
