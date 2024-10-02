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
    private let movie: MovieProtocol

    // MARK: - Init
    init(movie: MovieProtocol, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.movie = movie
        self.networkManager = networkManager
    }

    func fetchMovie() {
        presenter?.didFetchMovie(movie)
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
}
