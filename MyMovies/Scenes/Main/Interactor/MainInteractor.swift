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
            case .success(let movieListsPagedResponse):
                self?.presenter?.didFetchMovieLists(movieListsPagedResponse.results)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // Fetch genres
    func fetchMovieGenres() {
        NetworkManager.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let genresResponse):
                self?.presenter?.didFetchMovieGenres(genresResponse.data)
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
                self?.presenter?.didFetchTopMovies(movieLists.results)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }
}
