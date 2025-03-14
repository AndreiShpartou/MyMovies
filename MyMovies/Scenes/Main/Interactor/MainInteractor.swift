//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainInteractor: MainInteractorProtocol, PrefetchInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let genreRepository: GenreRepositoryProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let provider: Provider

    // MARK: - Init
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        genreRepository: GenreRepositoryProtocol = GenreRepository(),
        movieRepository: MovieRepositoryProtocol = MovieRepository()
    ) {
        self.networkManager = networkManager
        self.genreRepository = genreRepository
        self.movieRepository = movieRepository
        self.provider = networkManager.getProvider()
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
        // Show movies from storing for default genre
        if genre.name == "All" {
            fetchMovies(type: .popularMovies)

            return
        }

        networkManager.fetchMoviesByGenre(type: .popularMovies, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: .popularMovies, saveToStorage: false)
        }
    }

    // Get top rated movies filtered by genre
    func fetchTopRatedMoviesWithGenresFiltering(genre: GenreProtocol) {
        // Show movies from storing for default genre
        if genre.name == "All" {
            fetchMovies(type: .topRatedMovies)

            return
        }

        networkManager.fetchMoviesByGenre(type: .topRatedMovies, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: .topRatedMovies, saveToStorage: false)
        }
    }

    // Get the highest grossing movies filtered by genre
    func fetchTheHighestGrossingMoviesWithGenresFiltering(genre: GenreProtocol) {
        // Show movies from storing for default genre
        if genre.name == "All" {
            fetchMovies(type: .theHighestGrossingMovies)

            return
        }

        networkManager.fetchMoviesByGenre(type: .theHighestGrossingMovies, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: .theHighestGrossingMovies, saveToStorage: false)
        }
    }

    // Prefetch
    func prefetchData() {
        fetchMovieGenres()
        fetchUpcomingMovies()
        fetchPopularMovies()
        fetchTopRatedMovies()
        fetchTheHighestGrossingMovies()
    }

    // MARK: - Genres
    // Fetch genres
    func fetchMovieGenres() {
        // Check if there are any cached genres
        let cachedGenres = genreRepository.fetchGenres(provider: provider.rawValue)
        if !cachedGenres.isEmpty {
            // Immediately present to the user
            presenter?.didFetchMovieGenres(cachedGenres)

            return
        }

        // If no cached data, fetch from API
        networkManager.fetchGenres { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.presenter?.didFetchMovieGenres(genres)
                }
                // Save to CoreData
                if let movieGenres = genres as? [Movie.Genre] {
                    self.genreRepository.saveGenres(movieGenres, provider: self.provider.rawValue)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    // MARK: - Private
    private func fetchMovies(type: MovieListType) {
        // Check if the data for this list is stale.
        let lastUpdateKey = "lastUpdated_\(type.rawValue)_\(provider.rawValue)"
        let lastUpdated = UserDefaults.standard.double(forKey: lastUpdateKey)
        let now = Date().timeIntervalSince1970
        let isStale = (now - lastUpdated) > (86400) // 24 hours in seconds

        // Check if there are any cached movies if not stale
        if !isStale {
            let cachedMovies = movieRepository.fetchMoviesByList(provider: provider.rawValue, listType: type.rawValue)
            if !cachedMovies.isEmpty {
                // Immediately present to the user
                presentMovies(cachedMovies, for: type)

                return
            }
        } else {
            // Delete stale movie memberships
            movieRepository.clearMoviesForList(provider: provider.rawValue, listName: type.rawValue)
        }

        // If no cached data, fetch from API
        networkManager.fetchMovies(type: type) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type)
        }
    }

    // Centralized handling of movie fetch results
    private func handleMovieFetchResult(
        _ result: Result<[MovieProtocol], Error>,
        fetchType: MovieListType,
        saveToStorage: Bool = true
    ) {
        switch result {
        case .success(let movies):
            networkManager.fetchMoviesDetails(for: movies, type: fetchType) { [weak self] detailedMovies in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.presentMovies(detailedMovies, for: fetchType)
                }

                if saveToStorage {
                    self.saveMoviesToStorage(detailedMovies, type: fetchType)
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

    private func saveMoviesToStorage(_ movies: [MovieProtocol], type: MovieListType) {
        // Save to CoreData
        if let movies = movies as? [Movie] {
            // Store movies with new list membership
            movieRepository.storeMoviesForList(
                movies,
                provider: provider.rawValue,
                listType: type.rawValue
            )
        }

        // Update lastUpdated for the list type
        let now = Date().timeIntervalSince1970
        let lastUpdateKey = "lastUpdated_\(type.rawValue)_\(provider.rawValue)"
        UserDefaults.standard.set(now, forKey: lastUpdateKey)
    }
}
