//
//  MovieListInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MovieListInteractor: MovieListInteractorProtocol {
    weak var presenter: MovieListInteractorOutputProtocol?
    private var listType: MovieListType?
    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - Genres
    // Fetch genres
    func fetchMovieGenres(type: MovieListType) {
        switch type {
        case .searchedMovies:
            // APIs don't support genre filtering for searched movies
            DispatchQueue.main.async {
                self.presenter?.didFetchMovieGenres([])
            }
        default:
            fetchGenres()
        }
    }

    // MARK: - FetchMovies
    // Fetch list of movies by type
    func fetchMovieList(type: MovieListType) {
        fetchMovies(type: type)
        // Save type for the case of further filtering by genre
        listType = type
    }

    // Fetch movie list by genre
    func fetchMovieListWithGenresFiltering(genre: GenreProtocol) {
        guard let type = listType else {
            return
        }

        networkManager.fetchMoviesByGenre(type: type, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type)
        }
    }

    // MARK: - Private
    private func fetchGenres() {
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

    private func fetchMovies(type: MovieListType) {
        networkManager.fetchMovies(type: type) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type)
        }
    }

    // Centralized handling of movie fetch results
    private func handleMovieFetchResult(_ result: Result<[MovieProtocol], Error>, fetchType: MovieListType) {
        switch result {
        case .success(let movies):
            self.fetchDetails(for: movies, fetchType: fetchType)
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    private func fetchDetails(for movies: [MovieProtocol], fetchType: MovieListType) {
        switch fetchType {
        case .searchedMovies:
            // Kinopoisk API doesn't contain movie details in search results
            // Fetch details with a single request for all movies
            // Kinopoisk API supports multiple movie details request
            // Disabled for the TMDB API. It returns the same movie collection without requests
            self.fetchMoviesDetails(for: movies.map { $0.id }, defaultValue: movies)
        default:
            self.fetchMoviesDetails(for: movies)
        }
    }

    private func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol]) {
        networkManager.fetchMoviesDetails(for: ids, defaultValue: defaultValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detailedMovies):
                DispatchQueue.main.async {
                    // Fetch details with a separate request for each movie
                    // TMDB API does not support multiple movie details request
                    // Disabled for the Kinopoisk API. It returns the same movie collection without requests
                    self.fetchMoviesDetails(for: detailedMovies)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    private func fetchMoviesDetails(for movies: [MovieProtocol]) {
        networkManager.fetchMoviesDetails(for: movies, type: .searchedMovies(query: "")) { [weak self] detailedMovies in
            DispatchQueue.main.async {
                self?.presenter?.didFetchMovieList(detailedMovies)
            }
        }
    }
}
