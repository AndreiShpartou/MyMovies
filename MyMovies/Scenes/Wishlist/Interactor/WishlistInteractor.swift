//
//  WishlistInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class WishlistInteractor: WishlistInteractorProtocol {
    weak var presenter: WishlistInteractorOutputProtocol?

    private let movieRepository: MovieRepositoryProtocol
    private let provider: Provider

    // MARK: - Init
    init(
        movieRepository: MovieRepositoryProtocol = MovieRepository(),
        provider: Provider = NetworkManager.shared.getProvider()
    ) {
        self.movieRepository = movieRepository
        self.provider = provider
    }

    // MARK: - Public
    func fetchWishlist() {
        presenter?.didFetchWishlist([])
    }
}
