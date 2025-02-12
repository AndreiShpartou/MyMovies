//
//  PersonDetailsPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

final class PersonDetailsPresenter: PersonDetailsPresenterProtocol {
    weak var view: PersonDetailsViewProtocol?
    var interactor: PersonDetailsInteractorProtocol
    var router: PersonDetailsRouterProtocol

    private let mapper: DomainModelMapperProtocol

    // MARK: - Init
    init(
        view: PersonDetailsViewProtocol? = nil,
        interactor: PersonDetailsInteractorProtocol,
        router: PersonDetailsRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - Public
    func viewDidLoad() {
        view?.showLoading()
        interactor.fetchDetails()
    }

    func didSelectMovie(movie: MovieProtocol) {
        router.navigateToMovieDetails(with: movie)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
    }
}

// MARK: - PeroonDetailsInteractorOutputProtocol
extension PersonDetailsPresenter: PersonDetailsInteractorOutputProtocol {
    func didFetchPersonDetails(_ person: PersonDetailedProtocol) {
        view?.hideLoading()
        guard let personViewModel = mapper.map(data: person, to: PersonDetailedViewModel.self) else {
            let error = AppError.customError(message: "Failed to map Detailed person", comment: "Error message for failed detailed person loading")
            view?.showError(error)

            return
        }

        view?.showPersonDetails(personViewModel)
    }

    func didFetchPersonRelatedMovies(_ movies: [MovieProtocol]) {
        guard let movieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Related movies", comment: "Error message for failed related movies loading")
            view?.showError(error)

            return
        }

        view?.showPersonRelatedMovies(movieViewModels)
    }

    func didFailToFetchData(with error: Error) {
        //        view?.showError(error)
        //        view?.hideLoading()
    }
}
