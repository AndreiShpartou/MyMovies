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
    private var loadingStates: [MainAppSection: Bool] = [
        .rootView: false,
        .genres: false,
        .relatedMovies: false
    ]

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
        setLoading(for: .rootView, isLoading: true)
        interactor.fetchPersonDetails()

        setLoading(for: .genres, isLoading: true)
        interactor.fetchMovieGenres()

        setLoading(for: .relatedMovies, isLoading: true)
        interactor.fetchPersonRelatedMovies()
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map Genre", underlying: nil))

            return
        }

        interactor.fetchPersonRelatedMoviesWithGenresFiltering(for: movieGenre)
        setLoading(for: .relatedMovies, isLoading: true)
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
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map Person", underlying: nil))

            return
        }

        view?.showPersonDetails(personViewModel)
        self.person = person
        setLoading(for: .rootView, isLoading: false)
    }

    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        // Map to ViewModel
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map Genre", underlying: nil))

            return
        }

        view?.showMovieGenres(genreViewModels)
        setLoading(for: .genres, isLoading: false)
    }

    func didFetchPersonRelatedMovies(_ movies: [MovieProtocol]) {
        guard let movieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map related movies", underlying: nil))

            return
        }

        view?.showPersonRelatedMovies(movieViewModels)
        personRelatedMovies = movies
        setLoading(for: .relatedMovies, isLoading: false)
    }

    func didFailToFetchData(with error: Error) {
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))

        loadingStates.forEach { setLoading(for: $0.key, isLoading: false) }
    }
}

// MARK: - Private
private extension PersonDetailsPresenter {
    private func setLoading(for section: MainAppSection, isLoading: Bool) {
        loadingStates[section] = isLoading
        // Notify the view
        view?.setLoadingIndicator(for: section, isVisible: isLoading)
    }
}
