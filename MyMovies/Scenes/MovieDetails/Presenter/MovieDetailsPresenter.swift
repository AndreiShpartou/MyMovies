//
//  MovieDetailsPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    weak var view: MovieDetailsViewProtocol?
    var interactor: MovieDetailsInteractorProtocol
    var router: MovieDetailsRouterProtocol

    private let mapper: DomainModelMapperProtocol
    private var movieID: Int = 0
    private var similarMovies: [MovieProtocol] = []
    private var isFavourite = false {
        didSet {
            view?.delegate?.updateFavouriteButtonState(isSelected: isFavourite)
        }
    }

    // MARK: - Init
    init(
        view: MovieDetailsViewProtocol,
        interactor: MovieDetailsInteractorProtocol,
        router: MovieDetailsRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - Public
    func viewDidLoad() {
        interactor.fetchMovie()
        interactor.fetchReviews()
        interactor.fetchSimilarMovies()
        interactor.fetchIsMovieInList(listType: .favouriteMovies)

        setupObservers()
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
    }

    func didSelectMovie(movieID: Int) {
        guard let movie = similarMovies.first(where: { $0.id == movieID }) else {
            return
        }

        router.navigateToMovieDetails(with: movie)
    }

    func didSelectPerson(personID: Int) {
        router.navigateToPersonDetails(with: personID)
    }

    func presentReview(with author: String?, and text: String?) {
        router.navigateToReviewDetails(with: author, and: text, title: "Review")
    }

    func didTapFavouriteButton() {
        isFavourite.toggle()
        interactor.toggleFavouriteStatus(isFavourite: isFavourite)
    }
    
    func didTapHomePageButton(url: URL) {
        UIApplication.shared.open(url)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Setup
extension MovieDetailsPresenter {
    private func setupObservers() {
        // Subscribe to wishlist updates
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdate), name: .favouritesAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdate), name: .favouritesRemoved, object: nil)
    }
}

// MARK: - ActionMethods
extension MovieDetailsPresenter {
    @objc
    private func handleFavoritesUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let movieID = userInfo[NotificationKeys.movieID] as? Int,
              let isFavourite = userInfo[NotificationKeys.isFavourite] as? Bool else {
            return
        }

        // Update the button state if the movie matches
        if movieID == self.movieID, isFavourite != self.isFavourite {
            DispatchQueue.main.async { [weak self] in
                self?.isFavourite.toggle()
            }
        }
    }
}

// MARK: - MovieDetailsInteractorOutputProtocol
extension MovieDetailsPresenter: MovieDetailsInteractorOutputProtocol {
    func didFetchMovie(_ movie: MovieProtocol) {
        guard let movieDetailsViewModel = mapper.map(data: movie, to: MovieDetailsViewModel.self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map movie", underlying: nil))

            return
        }

        view?.showDetailedMovie(movieDetailsViewModel)
        self.movieID = movie.id
    }

    func didFetchReviews(_ reviews: [MovieReviewProtocol]) {
        guard let reviews = mapper.map(data: reviews, to: [ReviewViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map reviews", underlying: nil))

            return
        }

        view?.showMovieReviews(reviews)
    }

    func didFetchSimilarMovies(_ movies: [MovieProtocol]) {
        guard let similarMovies = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map similar movies", underlying: nil))

            return
        }

        view?.showSimilarMovies(similarMovies)
        self.similarMovies = movies
    }

    func didFetchIsMovieInList(_ isInList: Bool, listType: MovieListType) {
        if listType == .favouriteMovies, isInList != isFavourite {
            self.isFavourite.toggle()
        }
    }

    func didFailToFetchData(with error: Error) {
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))
    }
}
