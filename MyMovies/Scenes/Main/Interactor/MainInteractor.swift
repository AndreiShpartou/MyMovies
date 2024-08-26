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
    func fetchUpcomingMovies() {
        NetworkManager.shared.fetchUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.presenter?.didFetchUpcomingMovies(movies)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // Fetch genres
    func fetchMovieGenres() {
        NetworkManager.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                self?.presenter?.didFetchMovieGenres(genres)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
//        NetworkManager.shared.fetchGenres { [weak self] result in
//            switch result {
//            case .success(let genresResponse):
//                self?.presenter?.didFetchMovieGenres(genresResponse.genres)
//            case .failure(let error):
//                self?.presenter?.didFailToFetchData(with: error)
//            }
//        }
    }

    // MARK: - Fetch top movies
    func fetchPopularMovies() {
//        NetworkManager.shared.fetchTopMovies { [weak self] result in
//            switch result {
//            case .success(let movieLists):
//                self?.presenter?.didFetchTopMovies(movieLists.results)
//            case .failure(let error):
//                self?.presenter?.didFailToFetchData(with: error)
//            }
//        }
    }
}
