//
//  MovieDetailsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    weak var presenter: MovieDetailsInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private var movie: MovieProtocol

    // MARK: - Init
    init(movie: MovieProtocol, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.movie = movie
        self.networkManager = networkManager
    }

    // MARK: - Public
    func fetchMovie() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenter?.didFetchMovie(self.movie)
        }
    }

    func fetchReviews() {
        networkManager.fetchReviews(for: movie.id) { [weak self] result in
            switch result {
            case .success(let reviews):
                DispatchQueue.main.async {
                    self?.presenter?.didFetchReviews(reviews)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    func fetchSimilarMovies() {
        let type = MovieListType.similarMovies(id: movie.id)
        // Use the previously loaded similar movies id for onward fetching details (Kinopoisk API)
        if let similarMovies = movie.similarMovies,
           !similarMovies.isEmpty {
            let result: Result<[MovieProtocol], Error> = .success(similarMovies)
            handleMovieFetchResult(result, fetchType: type)
        } else {
            // Use a distinct endpoint for the TMDB API
            networkManager.fetchMovies(type: type) { [weak self] result in
                self?.handleMovieFetchResult(result, fetchType: type)
            }
        }
    }

    // MARK: - Private
    // Centralized handling of movie fetch results
    private func handleMovieFetchResult(_ result: Result<[MovieProtocol], Error>, fetchType: MovieListType) {
        switch result {
        case .success(let movies):
            networkManager.fetchMoviesDetails(for: movies, type: fetchType) { [weak self] detailedMovies in
                DispatchQueue.main.async {
                    self?.presenter?.didFetchSimilarMovies(detailedMovies)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }
}
