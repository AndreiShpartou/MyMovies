//
//  MovieDetailsPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    weak var view: MovieDetailsViewProtocol?
    var interactor: MovieDetailsInteractorProtocol
    var router: MovieDetailsRouterProtocol

    private let mapper: DomainModelMapperProtocol
    private var similarMovies: [MovieProtocol] = []

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
}

// MARK: - MovieDetailsInteractorOutputProtocol
extension MovieDetailsPresenter: MovieDetailsInteractorOutputProtocol {
    func didFetchMovie(_ movie: MovieProtocol) {
        guard let movieDetailsViewModel = mapper.map(data: movie, to: MovieDetailsViewModel.self) else {
            return
        }

        view?.showDetailedMovie(movieDetailsViewModel)
    }

    func didFetchReviews(_ reviews: [MovieReviewProtocol]) {
        guard let reviews = mapper.map(data: reviews, to: [ReviewViewModel].self) else {
            return
        }

        view?.showMovieReviews(reviews)
    }

    func didFetchSimilarMovies(_ movies: [MovieProtocol]) {
        guard let similarMovies = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showSimilarMovies(similarMovies)
        self.similarMovies = movies
    }

    func didFailToFetchData(with error: Error) {
        //
    }
}
