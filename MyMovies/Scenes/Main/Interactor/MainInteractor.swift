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
                self?.fetchMoviesDetails(for: movies) { detailedMovies in
                    self?.presenter?.didFetchUpcomingMovies(detailedMovies)
                }
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
    }

    // MARK: - Fetch top movies
    func fetchPopularMovies() {
        NetworkManager.shared.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.fetchMoviesDetails(for: movies) { detailedMovies in
                    self?.presenter?.didFetchPopularMovies(detailedMovies)
                }
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // MARK: - Private
    private func fetchMoviesDetails(for movies: [MovieProtocol], completion: @escaping ([MovieProtocol]) -> Void) {
        var detailedMovies = [MovieProtocol]()
        let dispatchGroup = DispatchGroup()

        movies.forEach { movie in
            dispatchGroup.enter()
            NetworkManager.shared.fetchMovieDetails(for: movie) { [weak self] result in
                switch result {
                case .success(let detailedMovie):
                    detailedMovies.append(detailedMovie)
                case .failure(let error):
                    self?.presenter?.didFailToFetchData(with: error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(detailedMovies)
        }
    }
}
