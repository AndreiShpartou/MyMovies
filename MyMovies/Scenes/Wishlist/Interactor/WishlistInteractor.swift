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
        movieRepository: MovieRepositoryProtocol,
        provider: Provider
    ) {
        self.movieRepository = movieRepository
        self.provider = provider
    }

    // MARK: - Public
    func fetchWishlist() {
        do {
            let favouriteMovies = try movieRepository.fetchMoviesByList(provider: provider.rawValue, listType: listName)
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFetchWishlist(favouriteMovies)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }

    func removeMovieFromWishlist(movieID: Int) {
        movieRepository.removeMovieFromList(movieID, provider: provider.rawValue, listName: listName) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            default:
                break
            }
        }
    }
}
