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
    // Temporary entities persistance switch to CoreData
    private var movies: [MovieProtocol] = []
    // A property to hold debouncing work item
    private var searchDebounceWorkItem: DispatchWorkItem?

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
        // Cancel any previously scheduled search
        searchDebounceWorkItem?.cancel()

        // Wrap search query in a DispatchWorkItem
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            view?.hideAllElements()
            view?.showLoading()
            self.interactor.performSearch(with: query)
        }
        searchDebounceWorkItem = workItem

        // Schedule the search after 0.84 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.84, execute: workItem)
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            let error = AppError.customError(message: "Failed to map Genres", comment: "Error message for failed genres loading")
            view?.showError(error)

            return
        }

        interactor.fetchUpcomingMoviesWithGenresFiltering(genre: movieGenre)
    }

    func didSelectMovie(movieID: Int) {
        // Handle movie selection
        guard let movie = movies.first(where: { $0.id == movieID }) else {
            return
        }

        router.navigateToMovieDetails(with: movie)
    }

    func didSelectPerson(personID: Int) {
        // Handle person selection
        // router.navigateToPersonDetails(with: personID)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
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

        view?.showInitialElements()
        view?.showGenres(genreViewModels)
    }

    func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        guard let upcomingMoviesViewModel = mapper.map(data: movies, to: [MovieListItemViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Upcoming Movies", comment: "Error message for failed movies loading")
            view?.showError(error)

            return
        }

        view?.showInitialElements()
        view?.showUpcomingMovies(upcomingMoviesViewModel)
        self.movies.append(contentsOf: movies)
    }

    func didFetchRecentlySearchedMovies(_ movies: [MovieProtocol]) {
        guard let recentlySearchedMoviesViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Recently Searched Movies", comment: "Error message for failed movies loading")
            view?.showError(error)

            return
        }

        view?.showInitialElements()
        view?.showRecentlySearchedMovies(recentlySearchedMoviesViewModels)
        self.movies.append(contentsOf: movies)
    }

    func didFetchMoviesSearchResults(_ movies: [MovieProtocol]) {
        view?.hideLoading()
        guard let searchResultsViewModels = mapper.map(data: movies, to: [MovieListItemViewModel].self) else {
            return
        }

        if searchResultsViewModels.isEmpty {
            view?.showNoResults()
        } else {
            view?.showMoviesSearchResults(searchResultsViewModels)
            self.movies.append(contentsOf: movies)
        }
    }

    func didFetchPersonsSearchResults(_ persons: [PersonProtocol]) {
        guard let personViewModels = mapper.map(data: persons, to: [PersonViewModel].self) else {
            let error = AppError.customError(message: "Failed to map Persons", comment: "Error message for failed persons loading")
            view?.showError(error)

            return
        }

        view?.showPersonsSearchResults(personViewModels)
    }

    func didFailToFetchData(with error: Error) {
        view?.hideLoading()
        view?.showError(error)
    }
}
