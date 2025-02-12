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
//        view?.showLoading()
//        interactor.fetchPersonDetails()
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
    func didFetchPersonDetails(_ person: PersonDetailsProtocol) {
        guard let personViewModel = mapper.map(data: person, to: PersonDetailedViewModel.self) else {
            //            view?.showError(NSLocalizedString("Failed to load person", comment: "Error message for failed person load"))
            //            view?.hideLoading()

            return
        }

        //        view?.showPersonDetails(personViewModel)
    }

    func didFailToFetchData(with error: Error) {
        //        view?.showError(error)
        //        view?.hideLoading()
    }
}
