//
//  SearchPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol
    var router: SearchRouterProtocol

    private let mapper: DomainModelMapperProtocol

    // MARK: - Init
    init(
        view: SearchViewProtocol? = nil,
        interactor: SearchInteractorProtocol,
        router: SearchRouterProtocol,
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
        interactor.fetchInitialData()
//        interactor.fetchRecentlySearchedMovies()
    }

    func didSearch(query: String) {
        view?.showLoading()
        interactor.performSearch(with: query)
    }

    // MARK: - Private
    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        //
    }

    func didSelectMovie(movieID: Int) {
        // Handle movie selection
//        router.navigateToMovieDetails(with: <#T##MovieProtocol#>)
    }

    func didSelectPerson(personID: Int) {
        // Handle person selection
        // router.navigateToPersonDetails(with: personID)
    }

    func didTapSeeAllButton() {
        // router.navigateToMovieList()
    }
}

// MARK: - SearchInteractorOutputProtocol
extension SearchPresenter: SearchInteractorOutputProtocol {
    func didFetchGenres(_ genres: [GenreProtocol]) {
        view?.hideLoading()
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Genres", comment: "Error message for failed genres loading")
            view?.showError(error)

            return
        }

        view?.showGenres(genreViewModels)
    }

    func didFetchUpcomingMovie(_ movie: MovieProtocol) {
        guard let upcomingMovieViewModel = mapper.map(data: movie, to: MovieListItemViewModel.self) else {
            let error = AppError.customError(message: "Failed to map Upcoming Movies", comment: "Error message for failed movies loading")
            view?.showError(error)

            return
        }

        view?.showUpcomingMovie(upcomingMovieViewModel)
    }

    func didFetchRecentlySearchedMovies(_ movies: [MovieProtocol]) {
        guard let recentlySearchedMoviesViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Recently Searched Movies", comment: "Error message for failed movies loading")
            view?.showError(error)

            return
        }

        view?.showRecentlySearchedMovies(recentlySearchedMoviesViewModels)
    }

    func didFetchSearchResults(_ movies: [MovieProtocol]) {
        view?.hideLoading()
        guard let searchResultsViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        if searchResultsViewModels.isEmpty {
            view?.showNoResults()
        } else {
            view?.showSearchResults(searchResultsViewModels)
        }
    }

    func didFetchPersonResults(_ persons: [PersonProtocol], relatedMovies: [MovieProtocol]) {
        guard let personViewModels = mapper.map(data: persons, to: [PersonViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Persons", comment: "Error message for failed persons loading")
            view?.showError(error)

            return
        }

        guard let relatedMoviesViewModels = mapper.map(data: relatedMovies, to: [BriefMovieListItemViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Related Movies", comment: "Error message for failed related movies loading")
            view?.showError(error)

            return
        }

        view?.showPersonResults(personViewModels, relatedMovies: relatedMoviesViewModels)
    }

    func didFailToFetchData(with error: Error) {
        view?.hideLoading()
        view?.showError(error)
    }
}
