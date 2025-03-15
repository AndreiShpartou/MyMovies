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
    private var person: PersonDetailedProtocol?
    private var personRelatedMovies: [MovieProtocol] = []

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
        interactor.fetchPersonDetails()
        interactor.fetchMovieGenres()
        interactor.fetchPersonRelatedMovies()
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            return
        }

        interactor.fetchPersonRelatedMoviesWithGenresFiltering(for: movieGenre)
    }

    func didSelectMovie(movieID: Int) {
        guard let movie = personRelatedMovies.first(where: { $0.id == movieID }) else {
            return
        }

        router.navigateToMovieDetails(with: movie)
    }

    func didTapSeeAllButton() {
        guard let person = self.person else {
            return
        }
        router.navigateToMovieList(type: .personRelatedMovies(id: person.id))
    }
}

// MARK: - PeroonDetailsInteractorOutputProtocol
extension PersonDetailsPresenter: PersonDetailsInteractorOutputProtocol {
    func didFetchPersonDetails(_ person: PersonDetailedProtocol) {
        guard let personViewModel = mapper.map(data: person, to: PersonDetailedViewModel.self) else {
            let error = AppError.customError(message: "Failed to map Detailed person", comment: "Error message for failed detailed person loading")
            view?.showError(error)

            return
        }

        view?.showPersonDetails(personViewModel)
        self.person = person
    }

    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        // Map to ViewModel
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Genres", comment: "Error message for failed genres loading")
            view?.showError(error)

            return
        }

        view?.showMovieGenres(genreViewModels)
    }

    func didFetchPersonRelatedMovies(_ movies: [MovieProtocol]) {
        view?.hideLoading()
        guard let movieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Related movies", comment: "Error message for failed related movies loading")
            view?.showError(error)

            return
        }

        view?.showPersonRelatedMovies(movieViewModels)
        personRelatedMovies = movies
    }

    func didFailToFetchData(with error: Error) {
        //        view?.showError(error)
        //        view?.hideLoading()
    }
}
