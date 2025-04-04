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
        view?.setLoadingIndicator(isVisible: true)
        interactor.fetchWishlist()

        setupObservers()
    }

    func didSelectMovie(movieID: Int) {
        guard let movie = movies.first(where: { $0.id == movieID }) else { return }
        router.navigateToMovieDetails(with: movie)
    }

    func didTapRemoveButton(for movieID: Int) {
        didRemoveMovie(movieID: movieID)
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavouritesUpdate), name: .favouritesAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavouritesUpdate), name: .favouritesRemoved, object: nil)
    }
}

// MARK: - Action Methods
extension WishlistPresenter {
    @objc
    private func handleFavouritesUpdate(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let movieID = userInfo[NotificationKeys.movieID] as? Int else {
            return
        }

        if notification.name == .favouritesAdded {
            DispatchQueue.main.async { [weak self] in
                // Reload wishlist when favourites are updated
                self?.interactor.fetchWishlist()
            }
        }

        if notification.name == .favouritesRemoved {
            DispatchQueue.main.async { [weak self] in
                self?.didRemoveMovie(movieID: movieID)
            }
        }
    }
}

// MARK: - Helpers
extension WishlistPresenter {
    private func didRemoveMovie(movieID: Int) {
        // Remove from local `movies` array
        guard let index = movies.firstIndex(where: { $0.id == movieID }) else { return }
        movies.remove(at: index)

        // Tell the view to remove that index
        view?.removeMovie(at: index)
    }
}

// MARK: - WishlistInteractorOutputProtocol
extension WishlistPresenter: WishlistInteractorOutputProtocol {
    func didFetchWishlist(_ movies: [MovieProtocol]) {
        guard let favouriteMoviesViewModels = mapper.map(data: movies, to: [WishlistItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map movies", underlying: nil))

            return
        }

        view?.showMovies(favouriteMoviesViewModels)
        self.movies = movies
        view?.setLoadingIndicator(isVisible: false)
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))

        view?.setLoadingIndicator(isVisible: false)
    }
}
