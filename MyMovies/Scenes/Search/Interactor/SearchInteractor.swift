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
        // Fetch genres, upcoming movie
        let group = DispatchGroup()

        var fetchedGenres: [GenreProtocol] = []
        var fetchedUpcomingMovie: MovieProtocol?

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

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter?.didFetchGenres(fetchedGenres)
            if let movie = fetchedUpcomingMovie {
                self.presenter?.didFetchUpcomingMovie(movie)
            }
        }
    }

    func performSearch(with query: String) {
        guard !query.isEmpty else {
            fetchInitialData()

            return
        }

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
        // Perform movie search
        networkManager.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.presenter?.didFetchSearchResults(movies)
//                self?.saveSearchQuery(query)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // MARK: - Private
    private func fetchRecentlySearchedMovies() {
        let recentlySearched = dataPersistenceManager.fetchRecentlySearchedMovies()
        presenter?.didFetchRecentlySearchedMovies(recentlySearched)
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
