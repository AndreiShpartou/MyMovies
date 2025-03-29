//
//  MainInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class MainInteractor: MainInteractorProtocol, PrefetchInteractorProtocol {
    weak var presenter: MainInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let genreRepository: GenreRepositoryProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let provider: Provider
    private let firestoreDB = Firestore.firestore()

    private var authObserver: NSObjectProtocol?
    private var firestoreObserver: ListenerRegistration?

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

        setupAuthObserver()
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
        fetchUserProfile()
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

    // MARK: - UserProfile
    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            return
        }

        // Fetch full data and update UI if user is signed in
        fetchAdditionalUserData(uid: user.uid, email: email)

        // Add a listener to fetch user data if still not added
        setupFireStoreListener(uid: user.uid, email: email)
    }

    // MARK: - Deinit
    deinit {
        if let authObserver = authObserver {
            Auth.auth().removeStateDidChangeListener(authObserver)
        }

        firestoreObserver?.remove()
        firestoreObserver = nil
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

// MARK: - Observers
extension MainInteractor {
    private func setupAuthObserver() {
        authObserver = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            guard let user = user,
            let email = user.email else {
                // User is signed out or does not exist
                self.firestoreObserver?.remove()
                firestoreObserver = nil

                DispatchQueue.main.async {
                    self.presenter?.didLogOut()
                }

                return
            }

            // Add a listener to fetch additional user data via Firestore
            self.setupFireStoreListener(uid: user.uid, email: email)
        }
    }

    private func setupFireStoreListener(uid: String, email: String) {
        guard firestoreObserver == nil else { return }

        firestoreObserver = firestoreDB.collection("users").document(uid).addSnapshotListener { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }

            fetchAdditionalUserData(uid: uid, email: email)
        }
    }
}

// MARK: - FireBaseFireStoreAuth
extension MainInteractor {
    // Fetch additional data from the Firestore
    private func fetchAdditionalUserData(uid: String, email: String) {
        firestoreDB.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }

                return
            }

            guard let userData = snapshot?.data() else {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: AppError.customError(message: "Failed to fetch user data", comment: "Error message for failed user data fetch"))
                }

                return
            }

            // Return if data wasn't stored -> Wait until it'll be stored and fetching be triggered by the listener
            guard let name = userData["name"] as? String else {
                return
            }

            let userProfile = UserProfile(
                id: uid,
                name: name,
                email: email,
                profileImageURL: userData["profileImageURL"] as? URL
            )

            DispatchQueue.main.async {
                self.presenter?.didFetchUserProfile(userProfile)
            }
        }
    }
}
