//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

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
        let categories = [Genre(name: "All"), Genre(name: "Comedy")]
        presenter?.didFetchCategories(categories)
    }
}
