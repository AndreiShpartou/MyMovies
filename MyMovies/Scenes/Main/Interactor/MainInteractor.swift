//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol?

    // Fetch collection of movie lists
    func fetchMovieLists() {
        NetworkManager.shared.fetchMovieLists { [weak self] result in
            switch result {
            case .success(let movieLists):
                self?.presenter?.didFetchMovieLists(movieLists.docs)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // Fetch categories
    func fetchMovieCategories() {
        NetworkManager.shared.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.presenter?.didFetchMovieCategories(categories)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // MARK: - Fetch top movies
    func fetchTopMovies() {
        NetworkManager.shared.fetchTopMovies { [weak self] result in
            switch result {
            case .success(let movieLists):
                self?.presenter?.didFetchTopMovies(movieLists.docs)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }
}
