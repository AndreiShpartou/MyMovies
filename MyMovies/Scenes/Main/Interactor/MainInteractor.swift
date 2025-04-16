//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainInteractor: MainInteractorProtocol, PrefetchInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol? {
        didSet {
            userProfileObserver.delegate = presenter
            userProfileObserver.startObserving()
        }
    }

    private let networkService: NetworkServiceProtocol
    private let genreRepository: GenreRepositoryProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let userProfileObserver: UserProfileObserverProtocol
    private let provider: Provider

    // MARK: - Init
    init(
        networkService: NetworkServiceProtocol,
        genreRepository: GenreRepositoryProtocol,
        movieRepository: MovieRepositoryProtocol,
        userProfileObserver: UserProfileObserverProtocol
    ) {
        self.networkService = networkService
        self.genreRepository = genreRepository
        self.movieRepository = movieRepository
        self.userProfileObserver = userProfileObserver
        self.provider = networkService.getProvider()
    }

    // MARK: - Movies
    func fetchMovies(with type: MovieListType) {
        fetchMovies(type: type)
    }

    // Movies filtered by genre
    func fetchMoviesByGenre(_ genre: GenreProtocol, listType: MovieListType) {
        fetchMoviesByGenre(genre, type: listType)
    }

    // Prefetch
    func prefetchData() {
        fetchUserProfile()
        fetchMovieGenres()
        [.upcomingMovies, .popularMovies, .topRatedMovies, .theHighestGrossingMovies].forEach { fetchMovies(type: $0) }
    }

    // MARK: - Genres
    // Fetch genres
    func fetchMovieGenres() {
        do {
            // Check if there are any cached genres
            let cachedGenres = try genreRepository.fetchGenres(provider: provider.rawValue)
            if !cachedGenres.isEmpty {
                DispatchQueue.main.async {
                    // Immediately present to the user
                    self.presenter?.didFetchMovieGenres(cachedGenres)
                }

                return
            }
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }
        }

        // If no cached data, fetch from API
        networkService.fetchGenres { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.presenter?.didFetchMovieGenres(genres)
                }
                // Save to CoreData
                if let movieGenres = genres as? [Movie.Genre] {
                    self.genreRepository.saveGenres(movieGenres, provider: self.provider.rawValue) { result in
                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.presenter?.didFailToFetchData(with: error)
                            }
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    // MARK: - UserProfile
    func fetchUserProfile() {
        userProfileObserver.fetchUserProfile()
    }

    // MARK: - Deinit
    deinit {
        userProfileObserver.stopObserving()
    }
}

// MARK: - Private
extension MainInteractor {
    // MARK: - FetchMovies
    private func fetchMovies(type: MovieListType) {
        // Check if the data for this list is stale.
        let lastUpdateKey = "lastUpdated_\(type.rawValue)_\(provider.rawValue)"
        let lastUpdated = UserDefaults.standard.double(forKey: lastUpdateKey)
        let now = Date().timeIntervalSince1970
        let isStale = (now - lastUpdated) > (86400) // 24 hours in seconds

        // Check if there are any cached  CoreData movies if not stale
        if !isStale {
            do {
                let cachedMovies = try movieRepository.fetchMoviesByList(provider: provider.rawValue, listType: type.rawValue)
                if !cachedMovies.isEmpty {
                    // Immediately present to the user
                    presentMovies(cachedMovies, for: type)

                    return
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        } else {
            // Delete stale movie memberships
            movieRepository.clearMoviesForList(provider: provider.rawValue, listName: type.rawValue) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presenter?.didFailToFetchData(with: error)
                    }
                default:
                    break
                }
            }
        }

        // If no cached data, fetch from API
        networkService.fetchMovies(type: type) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type)
        }
    }

    private func fetchMoviesByGenre(_ genre: GenreProtocol, type: MovieListType) {
        // Show movies from storing for default genre
        if genre.name == "All" {
            fetchMovies(type: type)

            return
        }

        networkService.fetchMoviesByGenre(type: type, genre: genre) { [weak self] result in
            self?.handleMovieFetchResult(result, fetchType: type, saveToStorage: false)
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
            networkService.fetchMoviesDetails(for: movies, type: fetchType) { [weak self] detailedMovies in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.presentMovies(detailedMovies, for: fetchType)
                }

                if saveToStorage {
                    self.saveMoviesToStorage(detailedMovies, type: fetchType)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    private func presentMovies(_ movies: [MovieProtocol], for type: MovieListType) {
        presenter?.didFetchMovies(movies, for: type)
    }

    private func saveMoviesToStorage(_ movies: [MovieProtocol], type: MovieListType) {
        // Save to CoreData
        if let movies = movies as? [Movie] {
            // Store movies with new list membership
            movieRepository.storeMoviesForList(
                movies,
                provider: provider.rawValue,
                listType: type.rawValue
            ) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presenter?.didFailToFetchData(with: error)
                    }
                default:
                    break
                }
            }
        }

        // Update lastUpdated for the list type
        let now = Date().timeIntervalSince1970
        let lastUpdateKey = "lastUpdated_\(type.rawValue)_\(provider.rawValue)"
        UserDefaults.standard.set(now, forKey: lastUpdateKey)
    }
}
