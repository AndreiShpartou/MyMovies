//
//  PersonDetailsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

final class PersonDetailsInteractor: PersonDetailsInteractorProtocol {
    weak var presenter: PersonDetailsInteractorOutputProtocol?

    private let networkService: NetworkServiceProtocol
    private let personID: Int
    private let genreRepository: GenreRepositoryProtocol
    private let provider: Provider
    // Token to track the current genre filtering requests
    private var currentGenreFilteringToken = UUID()

    // MARK: - Init
    init(
        personID: Int,
        networkService: NetworkServiceProtocol,
        genreRepository: GenreRepositoryProtocol
    ) {
        self.networkService = networkService
        self.personID = personID
        self.genreRepository = genreRepository
        self.provider = networkService.getProvider()
    }

    // MARK: - Public
    func fetchPersonDetails() {
        networkService.fetchPersonDetails(for: personID) { [weak self] result in
            switch result {
            case .success(let detailedPerson):
                DispatchQueue.main.async {
                    self?.presenter?.didFetchPersonDetails(detailedPerson)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    func fetchMovieGenres() {
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

    func fetchPersonRelatedMovies() {
        networkService.fetchPersonRelatedMovies(for: personID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.fetchMoviesDetails(for: movies)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    func fetchPersonRelatedMoviesWithGenresFiltering(for genre: GenreProtocol) {
        // Set up current request token
        let currentRequestToken = UUID()
        currentGenreFilteringToken = currentRequestToken

        let type = MovieListType.personRelatedMovies(id: personID)
        networkService.fetchMoviesByGenre(type: type, genre: genre) { [weak self] result in
            guard let self = self,
                  self.currentGenreFilteringToken == currentRequestToken else {
                return
            }

            switch result {
            case .success(let movies):
                self.fetchMoviesDetails(for: movies)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }
}

// MARK: - Private
extension PersonDetailsInteractor {
    private func fetchMoviesDetails(for movies: [MovieProtocol]) {
        networkService.fetchMoviesDetails(for: movies, type: .personRelatedMovies(id: personID)) { [weak self] detailedMovies in
            DispatchQueue.main.async {
                self?.presenter?.didFetchPersonRelatedMovies(detailedMovies)
            }
        }
    }
}
