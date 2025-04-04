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
    private let genreRepository: GenreRepositoryProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let provider: Provider
    // Token to track the current search request
    private var currentSearchToken: UUID?

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

    // MARK: - Public fetchInitialData
    func fetchInitialData() {
        // Fetch genres, upcoming movie
        let dispatchGroup = DispatchGroup()

        var fetchedGenres: [GenreProtocol] = []
        var fetchedUpcomingMovie: MovieProtocol?

        // Fetching genres
        let cachedGenres = fetchGenresFromStorage()
        if !cachedGenres.isEmpty {
            fetchedGenres = cachedGenres
        } else {
            dispatchGroup.enter()
            fetchGenres { genres in
                fetchedGenres = genres
                dispatchGroup.leave()
            }
        }

        // Fetching upcoming movies
        let cachedMovies = fetchMoviesFromStorage(for: .upcomingMovies)
        if !cachedMovies.isEmpty {
            fetchedUpcomingMovie = cachedMovies.first
        } else {
            dispatchGroup.enter()
            fetchUpcomingMovie { movie in
                fetchedUpcomingMovie = movie
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.presenter?.didFetchGenres(fetchedGenres)
                self.presenter?.didFetchUpcomingMovies(fetchedUpcomingMovie.map { [$0] } ?? [])
            }
        }
}

    // Get upcoming movies filtered by genre
    func fetchUpcomingMoviesWithGenresFiltering(genre: GenreProtocol) {
        if genre.name == "All" {
            let cachedMovies = fetchMoviesFromStorage(for: .upcomingMovies)
            if !cachedMovies.isEmpty {
                let firstMovie = cachedMovies.first
                presenter?.didFetchUpcomingMovies(firstMovie.map { [$0] } ?? [])

                return
            }
        }

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

    // MARK: - performSearch
    func performSearch(with query: String) {
        guard !query.isEmpty else {
            fetchInitialData()
            fetchRecentlySearchedMovies()

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

    // MARK: - fetchRecentlySearchedMovies
    func fetchRecentlySearchedMovies() {
        let recentlySearchedMovies = fetchMoviesFromStorage(for: .recentlySearchedMovies)
        presenter?.didFetchRecentlySearchedMovies(recentlySearchedMovies)
    }

    func fetchRecentlySearchedMoviesWithGenresFiltering(genre: GenreProtocol) {
        if genre.name == "All" {
            let cachedMovies = fetchMoviesFromStorage(for: .recentlySearchedMovies)
            if !cachedMovies.isEmpty {
                presenter?.didFetchRecentlySearchedMovies(cachedMovies)

                return
            }
        }

        do {
            let movies = try movieRepository.fetchMoviesByGenre(
                genre: genre,
                provider: provider.rawValue,
                listType: MovieListType.recentlySearchedMovies.rawValue
            )

            DispatchQueue.main.async {
                self.presenter?.didFetchRecentlySearchedMovies(movies)
            }
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    // MARK: - Private
    private func fetchGenresFromStorage() -> [GenreProtocol] {
        do {
            let genres = try genreRepository.fetchGenres(provider: provider.rawValue)

            return genres
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }

            return []
        }
    }

    private func fetchMoviesFromStorage(for listType: MovieListType) -> [MovieProtocol] {
        do {
            let movies = try movieRepository.fetchMoviesByList(provider: provider.rawValue, listType: listType.rawValue)

            return movies
        } catch {
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }

            return []
        }
    }

    private func fetchGenres(completion: @escaping ([GenreProtocol]) -> Void) {
        networkManager.fetchGenres { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let genres):
                completion(genres)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                    completion([])
                }
            }
        }
    }

    private func fetchUpcomingMovie(completion: @escaping (MovieProtocol?) -> Void) {
        networkManager.fetchMovies(type: .upcomingMovies) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let movies):
                guard let movie = movies.first else {
                    DispatchQueue.main.async {
                        self.presenter?.didFetchUpcomingMovies([])
                        completion(nil)
                    }

                    return
                }

                self.networkManager.fetchMoviesDetails(for: [movie], type: .upcomingMovies) { detailedMovies in
                    DispatchQueue.main.async {
                        completion(detailedMovies.first)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                    completion(nil)
                }
            }
        }
    }

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
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.presenter?.didFetchMoviesSearchResults(detailedMovies)
            }

            if let firstMovie = detailedMovies.first {
                self.storeRecentlySearchedMovie(for: firstMovie)
            }
        }
    }

    private func storeRecentlySearchedMovie(for movie: MovieProtocol) {
        movieRepository.storeMovieForList(
            movie,
            provider: provider.rawValue,
            listType: MovieListType.recentlySearchedMovies.rawValue,
            orderIndex: 0
        ) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            default:
                break
            }
        }
    }
}
