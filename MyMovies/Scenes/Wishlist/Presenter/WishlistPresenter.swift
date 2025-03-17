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
    }

    func didSelectMovie(movieID: Int) {
        guard let movie = movies.first(where: { $0.id == movieID }) else { return }
        router.navigateToMovieDetails(with: movie)
    }

    func removeMovie(movieID: Int) {
        interactor.removeMovieFromWishlist(movieID: movieID)
    }
}

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
