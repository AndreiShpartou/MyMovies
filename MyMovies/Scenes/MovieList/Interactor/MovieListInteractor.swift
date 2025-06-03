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
    private let networkService: NetworkServiceProtocol
    private let genreRepository: GenreRepositoryProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let provider: Provider
    // Token to track the current genre filtering requests
    private var currentGenreFilteringToken = UUID()

    // MARK: - Init
    init(
        networkService: NetworkServiceProtocol,
        genreRepository: GenreRepositoryProtocol,
        movieRepository: MovieRepositoryProtocol
    ) {
        self.networkService = networkService
        self.genreRepository = genreRepository
        self.movieRepository = movieRepository
        provider = networkService.getProvider()
    }

    // MARK: - Genres
    // Fetch genres
    func fetchMovieGenres(type: MovieListType) {
        switch type {
        case .searchedMovies, .similarMovies:
            // APIs don't support genre filtering
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

        // Set up current request token
        let currentRequestToken = UUID()
        currentGenreFilteringToken = currentRequestToken

        // Show movies from storing for default genre
        if genre.name == "All" {
            fetchMovies(type: type)

            return
        }

        if type == .recentlySearchedMovies {
            do {
                // Custom filtering from the local storage
                let movies = try movieRepository.fetchMoviesByGenre(
                    genre: genre,
                    provider: provider.rawValue,
                    listType: type.rawValue
                )
                DispatchQueue.main.async {
                    self.presenter?.didFetchMovieList(movies)
                }

                return
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }

        // Default API filtering
        networkService.fetchMoviesByGenre(type: type, genre: genre) { [weak self] result in
            guard let self = self,
                  self.currentGenreFilteringToken == currentRequestToken else {
                return
            }

            self.handleMovieFetchResult(result, fetchType: type)
        }
    }

    // MARK: - Private
    private func fetchGenres() {
        do {
            let localGenres = try genreRepository.fetchGenres(provider: provider.rawValue)
            if !localGenres.isEmpty {
                DispatchQueue.main.async {
                    // Immediately present to the user
                    self.presenter?.didFetchMovieGenres(localGenres)
                }

                return
            }
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }
        }

        networkService.fetchGenres { [weak self] result in
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

    // Check if there are any cached movies
    private func fetchMovies(type: MovieListType) {
        do {
            let cachedMovies = try movieRepository.fetchMoviesByList(provider: provider.rawValue, listType: type.rawValue)
            if !cachedMovies.isEmpty {
                // Immediately present to the user
                DispatchQueue.main.async {
                    self.presenter?.didFetchMovieList(cachedMovies)
                }

                return
            }
            // If no cached data and type is "Recently Searched Movies", don't invoke API
            if type == .recentlySearchedMovies {
                DispatchQueue.main.async {
                    self.presenter?.didFetchMovieList([])
                }
                return
            }
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }
        }

        // If no cached data, fetch from API
        networkService.fetchMovies(type: type) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type)
        }
    }

    // Centralized handling of movie fetch results
    private func handleMovieFetchResult(_ result: Result<[MovieProtocol], Error>, fetchType: MovieListType) {
        switch result {
        case .success(let movies):
            self.fetchDetails(for: movies, fetchType: fetchType)
        case .failure(let error):
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
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
        case .similarMovies:
            guard let similarMovies = movies.first?.similarMovies else {
                DispatchQueue.main.async {
                    self.fetchMoviesDetails(for: movies)
                }

                return
            }

            self.fetchMoviesDetails(for: similarMovies.map { $0.id }, defaultValue: similarMovies)
        default:
            self.fetchMoviesDetails(for: movies)
        }
    }

    private func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol]) {
        networkService.fetchMoviesDetails(for: ids, defaultValue: defaultValue) { [weak self] result in
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
        networkService.fetchMoviesDetails(for: movies, type: .searchedMovies(query: "")) { [weak self] detailedMovies in
            DispatchQueue.main.async {
                self?.presenter?.didFetchMovieList(detailedMovies)
            }
        }
    }
}
