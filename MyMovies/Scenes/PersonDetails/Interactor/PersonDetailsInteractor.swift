//
//  PersonDetailsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

final class PersonDetailsInteractor: PersonDetailsInteractorProtocol {
    weak var presenter: PersonDetailsInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let personID: Int

    // MARK: - Init
    init(personID: Int, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        self.personID = personID
    }

    // MARK: - Public
    func fetchDetails() {
        fetchPersonDetails()
        fetchPersonRelatedMovies()
    }
}

// MARK: - Private
extension PersonDetailsInteractor {
    private func fetchPersonDetails() {
        networkManager.fetchPersonDetails(for: personID) { [weak self] result in
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

    private func fetchPersonRelatedMovies() {
        networkManager.fetchPersonRelatedMovies(for: personID) { [weak self] result in
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

    private func fetchMoviesDetails(for movies: [MovieProtocol]) {
        networkManager.fetchMoviesDetails(for: movies, type: .personRelatedMovies(id: personID)) { [weak self] detailedMovies in
            DispatchQueue.main.async {
                self?.presenter?.didFetchPersonRelatedMovies(detailedMovies)
            }
        }
    }
}
