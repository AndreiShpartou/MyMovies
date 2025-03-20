//
//  WishlistInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class WishlistInteractor: WishlistInteractorProtocol {
    weak var presenter: WishlistInteractorOutputProtocol?

    private let listName = MovieListType.favouriteMovies.rawValue
    private let provider: Provider
    private let movieRepository: MovieRepositoryProtocol

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
        let favouriteMovies = movieRepository.fetchMoviesByList(provider: provider.rawValue, listType: listName)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenter?.didFetchWishlist(favouriteMovies)
        }
    }

    func removeMovieFromWishlist(movieID: Int) {
        movieRepository.removeMovieFromList(movieID, provider: provider.rawValue, listName: listName)
    }
}
