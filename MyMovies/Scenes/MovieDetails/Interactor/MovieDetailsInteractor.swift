//
//  MovieDetailsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    weak var presenter: MovieDetailsInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let provider: Provider
    private var movie: MovieProtocol

    // MARK: - Init
    init(
        movie: MovieProtocol,
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        movieRepository: MovieRepositoryProtocol = MovieRepository()
    ) {
        self.movie = movie
        self.networkManager = networkManager
        self.movieRepository = movieRepository
        self.provider = networkManager.getProvider()
    }

    // MARK: - Public
    func fetchMovie() {
        DispatchQueue.main.async {
            self.presenter?.didFetchMovie(self.movie)
        }
    }

    func fetchReviews() {
        networkManager.fetchReviews(for: movie.id) { [weak self] result in
            switch result {
            case .success(let reviews):
                DispatchQueue.main.async {
                    self?.presenter?.didFetchReviews(reviews)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    func fetchSimilarMovies() {
        let type = MovieListType.similarMovies(id: movie.id)
        if let similarMovies = movie.similarMovies {
            // Use the previously loaded similar movies id for onward fetching details (Kinopoisk API)
            // let result: Result<[MovieProtocol], Error> = .success(similarMovies)
            // handleMovieFetchResult(result, fetchType: type)
            self.fetchMoviesDetails(
                for: similarMovies.map { $0.id },
                defaultValue: similarMovies,
                fetchType: type
            )
        } else {
            // Use a distinct endpoint for the TMDB API
            networkManager.fetchMovies(type: type) { [weak self] result in
                self?.handleMovieFetchResult(result, fetchType: type)
            }
        }
    }

    func fetchIsMovieInList(listType: MovieListType) {
        do {
            let movieInList = try movieRepository.fetchMovieByID(
                movie.id,
                provider: provider.rawValue,
                listType: listType.rawValue
            )

            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFetchIsMovieInList(movieInList != nil, listType: listType)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    func toggleFavouriteStatus(isFavourite: Bool) {
        if isFavourite {
            movieRepository.storeMovieForList(
                movie,
                provider: provider.rawValue,
                listType: MovieListType.favouriteMovies.rawValue,
                orderIndex: 0
            ) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.presenter?.didFailToFetchData(with: error)
                default:
                    break
                }
            }
        } else {
            movieRepository.removeMovieFromList(
                movie.id,
                provider: provider.rawValue,
                listName: MovieListType.favouriteMovies.rawValue
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

    // MARK: - Private
    private func fetchMoviesDetails(for ids: [Int], defaultValue: [MovieProtocol], fetchType: MovieListType) {
        networkManager.fetchMoviesDetails(for: ids, defaultValue: defaultValue) { [weak self] result in
            guard let self = self else { return }
            self.handleMovieFetchResult(result, fetchType: fetchType)
        }
    }

    // Centralized handling of movie fetch results
    private func handleMovieFetchResult(_ result: Result<[MovieProtocol], Error>, fetchType: MovieListType) {
        switch result {
        case .success(let movies):
            networkManager.fetchMoviesDetails(for: movies, type: fetchType) { detailedMovies in
                DispatchQueue.main.async {
                    self.presenter?.didFetchSimilarMovies(detailedMovies)
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.presenter?.didFailToFetchData(with: error)
            }
        }
    }
}
