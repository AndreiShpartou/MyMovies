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

    // MARK: - Init
    init(personID: Int, networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.personID = personID
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
        networkService.fetchGenres { [weak self] (result: Result<[Genre], Error>) in
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
        networkService.fetchPersonRelatedMovies(for: personID) { [weak self] (result: Result<[Movie], Error>) in
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
        let type = MovieListType.personRelatedMovies(id: personID)
        networkService.fetchMoviesByGenre(type: type, genre: genre) { [weak self] (result: Result<[Movie], Error>) in
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
}

// MARK: - Private
extension PersonDetailsInteractor {
    private func fetchMoviesDetails(for movies: [Movie]) {
        networkService.fetchMoviesDetails(for: movies, type: .personRelatedMovies(id: personID)) { [weak self] (detailedMovies: [Movie]) in
            DispatchQueue.main.async {
                self?.presenter?.didFetchPersonRelatedMovies(detailedMovies)
            }
        }
    }
}
