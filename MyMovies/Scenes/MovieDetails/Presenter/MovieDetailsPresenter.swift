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

    func viewDidLoad() {
        interactor.fetchMovie()
        interactor.fetchReviews()
    }
}

// MARK: - MovieDetailsInteractorOutputProtocol
extension MovieDetailsPresenter: MovieDetailsInteractorOutputProtocol {
    func didFetchMovie(_ movie: MovieProtocol) {
        // Map to ViewModel
        guard let movieDetailsViewModel = mapper.map(data: movie, to: MovieDetailsViewModel.self) else {
            return
        }

        view?.showDetailedMovie(movieDetailsViewModel)
    }

    func didFetchReviews(_ reviews: [MovieReviewProtocol]) {
        // Map to ViewModel
//        guard let reviews = mapper.map(data: reviews, to: MovieDetailsViewModel.self) else {
//            return
//        }

//        view?.showmovieReviews(movieDetailsViewModel)
    }

    func didFailToFetchData(with error: Error) {
        //
    }
}
