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
    // Token to track the current search request
    private var currentSearchToken: UUID?

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
                DispatchQueue.main.async {
                    self?.presenter?.didFailToFetchData(with: error)
                }
            }
            group.leave()
        }

        // Fetching upcoming movies
        group.enter()
        networkManager.fetchMovies(type: .upcomingMovies) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let movies):
                guard let movie = movies.first else {
                    DispatchQueue.main.async {
                        self.presenter?.didFetchUpcomingMovies([])
                    }

                    return
                }

                self.networkManager.fetchMoviesDetails(for: [movie], type: .upcomingMovies) { detailedMovies in
                    DispatchQueue.main.async {
                        fetchedUpcomingMovie = detailedMovies.first
                        group.leave()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)

                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.presenter?.didFetchGenres(fetchedGenres)
                if let movie = fetchedUpcomingMovie {
                    self.presenter?.didFetchUpcomingMovies([movie])
                } else {
                    self.presenter?.didFetchUpcomingMovies([])
                }
            }
        }
}

    // Get upcoming movies filtered by genre
    func fetchUpcomingMoviesWithGenresFiltering(genre: GenreProtocol) {
        networkManager.fetchMoviesByGenre(type: .upcomingMovies, genre: genre) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let movies):
                guard let movie = movies.first else {
                    DispatchQueue.main.async {
                        self.presenter?.didFetchUpcomingMovies([])
                    }

                    return
                }

                self.networkManager.fetchMoviesDetails(for: [movie], type: .upcomingMovies) { [weak self] detailedMovies in
                    if let movie = detailedMovies.first {
                        DispatchQueue.main.async {
                            self?.presenter?.didFetchUpcomingMovies([movie])
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.presenter?.didFetchUpcomingMovies([])
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

    func performSearch(with query: String) {
        guard !query.isEmpty else {
            fetchInitialData()

            return
        }

        // Create a new search token
        let token = UUID()
        currentSearchToken = token

        // Perform person search
        networkManager.searchPersons(query: query) { [weak self] result in
            guard let self = self, self.currentSearchToken == token else { return }
            switch result {
            case .success(let persons):
                // Fetch related movies
                DispatchQueue.main.async {
                    self.presenter?.didFetchPersonsSearchResults(persons)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
        // Perform movie search
        networkManager.searchMovies(query: query) { [weak self] result in
            guard let self = self, self.currentSearchToken == token else { return }
            switch result {
            case .success(let movies):
                // Fetch details with a single request for all movies
                // Kinopoisk API supports multiple movie details request
                // Disabled for the TMDB API. It returns the same movie collection without requests
                self.fetchMoviesDetails(for: movies.map { $0.id }, defaultValue: movies)

//                self?.saveSearchQuery(query)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    // MARK: - Private
    private func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol]) {
        networkManager.fetchMoviesDetails(for: ids, defaultValue: defaultValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detailedMovies):
                // Fetch details with a separate request for each movie
                // TMDB API does not support multiple movie details request
                // Disabled for the Kinopoisk API. It returns the same movie collection without requests
                self.fetchMoviesDetails(for: detailedMovies)
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
                self?.presenter?.didFetchMoviesSearchResults(detailedMovies)
            }
        }
    }

    private func fetchRecentlySearchedMovies() {
        let recentlySearched = dataPersistenceManager.fetchRecentlySearchedMovies()
        presenter?.didFetchRecentlySearchedMovies(recentlySearched)
    }

//    // Fetch related movies for the found person
//    private func fetchRelatedMovies(for persons: [PersonProtocol], token: UUID) {
//        // Fetch related movies for each person
//        var relatedMovies: [MovieProtocol] = []
//        let group = DispatchGroup()
//
//        for person in persons {
//            group.enter()
//            networkManager.fetchMovieByPerson(person: person) { [weak self] result in
//                guard let self = self, self.currentSearchToken == token else {
//                    group.leave()
//
//                    return
//                }
//
//                switch result {
//                case .success(let movies):
//                    relatedMovies.append(contentsOf: movies)
//                case .failure(let error):
//                    self.presenter?.didFailToFetchData(with: error)
//                }
//                group.leave()
//            }
//        }
//
//        group.notify(queue: .main) { [weak self] in
//            guard let self = self, self.currentSearchToken == token else { return }
//
//            self.presenter?.didFetchPersonsSearchResults(persons)
//            self.saveSearchQuery(persons.map { $0.name }.joined(separator: ", ") )
//        }
//    }

    private func saveSearchQuery(_ query: String) {
        // Save search query
        dataPersistenceManager.saveSearchQuery(query)
    }
}
