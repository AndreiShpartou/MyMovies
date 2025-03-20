//
//  WishlistPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class WishlistPresenter: WishlistPresenterProtocol {
    weak var view: WishlistViewProtocol?
    var interactor: WishlistInteractorProtocol
    var router: WishlistRouterProtocol

    private let mapper: DomainModelMapperProtocol
    private var movies: [MovieProtocol] = []
    // MARK: - Init
    init(
        view: WishlistViewProtocol? = nil,
        interactor: WishlistInteractorProtocol,
        router: WishlistRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - Public
    func viewDidLoad() {
        interactor.fetchWishlist()

        setupObservers()
    }

    func didSelectMovie(movieID: Int) {
        guard let movie = movies.first(where: { $0.id == movieID }) else { return }
        router.navigateToMovieDetails(with: movie)
    }

    func removeMovie(movieID: Int) {
        interactor.removeMovieFromWishlist(movieID: movieID)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Setup
extension WishlistPresenter {
    private func setupObservers() {
        // Subscribe to wishlist updates
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavouritesUpdate), name: .favouritesUpdated, object: nil)
    }
}

// MARK: - Action Methods
extension WishlistPresenter {
    @objc
    private func handleFavouritesUpdate() {
        // Reload wishlist when favourites are updated
        interactor.fetchWishlist()
    }
}

// MARK: - WishlistInteractorOutputProtocol
extension WishlistPresenter: WishlistInteractorOutputProtocol {
    func didFetchWishlist(_ movies: [MovieProtocol]) {
        guard let favouriteMoviesViewModels = mapper.map(data: movies, to: [WishlistItemViewModelProtocol].self) else {
            return
        }

        view?.showMovies(favouriteMoviesViewModels)
        self.movies = movies
    }

    func didFailToFetchData(error: Error) {
        // Handle error
        view?.showError(error: error)
    }
}
