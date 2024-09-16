//
//  MovieListInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieListInteractor: MovieListInteractorProtocol {
    var presenter: MovieListInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - Genres
    // Fetch genres
    func fetchMovieGenres() {
        networkManager.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                self?.presenter?.didFetchMovieGenres(genres)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // MARK: - FetchMovies
    // Fetch list of movies by type
    func fetchMovieList(type: MovieListType) {
        fetchMovies(type: type)
    }

    // MARK: - Private
    private func fetchMovies(type: MovieListType) {
        networkManager.fetchMovies(type: type) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type)
        }
    }

    // Centralized handling of movie fetch results
    private func handleMovieFetchResult(_ result: Result<[MovieProtocol], Error>, fetchType: MovieListType) {
        switch result {
        case .success(let movies):
            networkManager.fetchMoviesDetails(for: movies) { [weak self] detailedMovies in
                self?.presenter?.didFetchMovieList(detailedMovies)
            }
        case .failure(let error):
            presenter?.didFailToFetchData(with: error)
        }
    }
}
