//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainInteractor: MainInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - UpcomingMovies
    // Fetch collection of movie premiers
    func fetchUpcomingMovies() {
        fetchMovies(type: .upcomingMovies)
    }

    // MARK: - PopularMovies
    func fetchPopularMovies() {
        fetchMovies(type: .popularMovies)
    }

    // MARK: - TopRatedMovies
    func fetchTopRatedMovies() {
        fetchMovies(type: .topRatedMovies)
    }

    // MARK: - TheHighestGrossingMovies
    func fetchTheHighestGrossingMovies() {
        fetchMovies(type: .theHighestGrossingMovies)
    }

    // Get popular movies filtered by genre
    func fetchPopularMoviesWithGenresFiltering(genre: GenreProtocol) {
        networkManager.fetchMoviesByGenre(type: .popularMovies, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: .popularMovies)
        }
    }

    // Get top rated movies filtered by genre
    func fetchTopRatedMoviesWithGenresFiltering(genre: GenreProtocol) {
        networkManager.fetchMoviesByGenre(type: .topRatedMovies, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: .topRatedMovies)
        }
    }

    // Get the highest grossing movies filtered by genre
    func fetchTheHighestGrossingMoviesWithGenresFiltering(genre: GenreProtocol) {
        networkManager.fetchMoviesByGenre(type: .theHighestGrossingMovies, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: .theHighestGrossingMovies)
        }
    }

    // MARK: - Genres
    // Fetch genres
    func fetchMovieGenres() {
        networkManager.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self?.presenter?.didFetchMovieGenres(genres)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailToFetchData(with: error)
                }
            }
        }
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
            networkManager.fetchMoviesDetails(for: movies, type: fetchType) { [weak self] detailedMovies in
                DispatchQueue.main.async {
                    self?.presentMovies(detailedMovies, for: fetchType)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    private func presentMovies(_ movies: [MovieProtocol], for type: MovieListType) {
        switch type {
        case .upcomingMovies:
            presenter?.didFetchUpcomingMovies(movies)
        case .popularMovies:
            presenter?.didFetchPopularMovies(movies)
        case .topRatedMovies:
            presenter?.didFetchTopRatedMovies(movies)
        case .theHighestGrossingMovies:
            presenter?.didFetchTheHighestGrossingMovies(movies)
        default:
            break
        }
    }
}
