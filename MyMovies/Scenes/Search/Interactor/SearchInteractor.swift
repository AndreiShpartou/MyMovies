//
//  SearchInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class SearchInteractor: SearchInteractorProtocol {
    weak var presenter: SearchInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let dataPersistenceManager: DataPersistenceProtocol

    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        dataPersistenceManager: DataPersistenceProtocol = DataPersistenceManager.shared
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
                guard let movie = movies.first else {
                    return
                }

                self?.networkManager.fetchMoviesDetails(for: [movie], type: .upcomingMovies) { detailedMovies in
                    DispatchQueue.main.async {
                        fetchedUpcomingMovie = detailedMovies.first
                        group.leave()
                    }
                }
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
                group.leave()
            }
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
            self.presenter?.didFetchGenres(fetchedGenres)
            self.presenter?.didFetchPopularMovies(fetchedPopularMovies)
            if let movie = fetchedUpcomingMovie {
                self.presenter?.didFetchUpcomingMovie(movie)
            }
        }
    }

    func fetchPopularMovies() {
        //
    }

    func performSearch(with query: String) {
        guard !query.isEmpty else {
            fetchInitialData()

            return
        }

        if isPersonSearchQuery(query) {
            // Perform person search
            networkManager.searchPersons(query: query) { [weak self] result in
                switch result {
                case .success(let persons):
                    // Fetch related movies
                    self?.fetchRelatedMovies(for: persons)
                case .failure(let error):
                    self?.presenter?.didFailToFetchData(with: error)
                }
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

    func fetchRecentlySearchedMovies() {
        let recentlySearched = dataPersistenceManager.fetchRecentlySearchedMovies()
        presenter?.didFetchRecentlySearchedMovies(recentlySearched)
    }

    // MARK: - Private
    private func isPersonSearchQuery(_ query: String) -> Bool {
        return query.contains("person")
    }

    private func fetchRelatedMovies(for persons: [PersonProtocol]) {
        // Fetch related movies for each person
        var relatedMovies: [MovieProtocol] = []
        let group = DispatchGroup()

        for person in persons {
            group.enter()
            networkManager.fetchMovieByPerson(person: person) { [weak self] result in
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
            self?.presenter?.didFetchPersonResults(persons, relatedMovies: relatedMovies)
            self?.saveSearchQuery(persons.map { $0.name }.joined(separator: ", ") )
        }
    }

    private func saveSearchQuery(_ query: String) {
        // Save search query
        dataPersistenceManager.saveSearchQuery(query)
    }
}
