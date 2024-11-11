//
//  SearchInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

// MARK: - Temporary protocols
protocol DataPersistenceManagerProtocol {
    func saveSearchQuery(_ query: String)
    func fetchRecentlySearchedMovies() -> [MovieProtocol]
}
class DataPersistenceManager: DataPersistenceManagerProtocol {
    func saveSearchQuery(_ query: String)
    func fetchRecentlySearchedMovies() -> [MovieProtocol]
}

class SearchInteractor: SearchInteractorProtocol {
    weak var presenter: SearchInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let dataPersistenceManager: DataPersistenceManagerProtocol

    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        dataPersistenceManager: DataPersistenceManagerProtocol = DataPersistenceManager()
    ) {
        self.networkManager = networkManager
        self.dataPersistenceManager = dataPersistenceManager
    }

    // MARK: - Public
    func fetchInitialData() {
        // Fetch genres, upcoming movie, popular movies
        let group = DispatchGroup()

        var fetchedGenres: [GenreProtocol] = []
        var fetchedUpcomingMovie: MovieProtocol?
        var fetchedPopularMovies: [MovieProtocol] = []

        // Fetching genres
        group.enter()
        networkManager.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                fetchedGenres = genres
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
            group.leave()
        }

        // Fetching upcoming movies
        group.enter()
        networkManager.fetchMovies(type: .upcomingMovies) { [weak self] result in
            switch result {
            case .success(let movies):
                fetchedUpcomingMovie = movies.first
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
            group.leave()
        }

        // Fetching popular movies
        group.enter()
        networkManager.fetchMovies(type: .popularMovies) { [weak self] result in
            switch result {
            case .success(let movies):
                fetchedPopularMovies = movies
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if let movie = fetchedUpcomingMovie {
                self?.presenter?.didFetchUpcomingMovie(movie)
            }
            self?.presenter?.didFetchGenres(fetchedGenres)
            self?.presenter?.didFetchPopularMovies(fetchedPopularMovies)
            self?.presenter?.didFetchRecentlySearchedMovies([])
        }
    }

    func performSearch(with query: String) {
        guard !query.isEmpty else {
            fetchInitialData()

            return
        }

        if isActorSearchQuery(query) {
            // Perform actor search
            networkManager.searchActors(query: query) { [weak self] result in
                switch result {
                case .success(let actors):
                    // Fetch related movies
                    self?.fetchRelatedMovies(for: actors)
                case .failure(let error):
                    self?.presenter?.didFailToFetchData(with: error)
                }
            } else {
                // Perform movie search
                networkManager.searchMovies(query: query) { [weak self] result in
                    switch result {
                    case .success(let movies):
                        self?.presenter?.didFetchSearchResults(movies)
                        self?.saveSearchQuery(query)
                    case .failure(let error):
                        self?.presenter?.didFailToFetchData(with: error)
                    }
                }
            }
        }
    }

    func fetchRecentlySearchedMovies() {
        let recentlySearched = dataPersistenceManager.fetchRecentlySearchedMovies()
        presenter?.didFetchRecentlySearchedMovies(recentlySearched)
    }

    // MARK: - Private
    private func isActorSearchQuery(_ query: String) -> Bool {
        return query.contains("actor")
    }

    private func fetchRelatedMovies(for actors: [ActorProtocol]) {
        // Fetch related movies for each actor
        var relatedMovies: [MovieProtocol] = []
        let group = DispatchGroup()

        for actor in actors {
            group.enter()
            networkManager.fetchMoviesByActor(actor: actor) { [weak self] result in
                switch result {
                case .success(let movies):
                    relatedMovies.append(contentsOf: movies)
                case .failure(let error):
                    self?.presenter?.didFailToFetchData(with: error)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.presenter?.didFetchActorResults(actors, relatedMovies: relatedMovies)
            self?.saveSearchQuery(actors.map { $0.name }.joined(separator: ", ") )
        }
    }

    private func saveSearchQuery(_ query: String) {
        // Save search query
        dataPersistenceManager.saveSearchQuery(query)
    }
}
