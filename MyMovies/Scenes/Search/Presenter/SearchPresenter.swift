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
    private var moviesDict: [MovieListType: [MovieProtocol]] = [:]
    private var persons: [PersonProtocol] = []
    // A property to hold debouncing work item
    private var searchDebounceWorkItem: DispatchWorkItem?
    // Loading indicators
    private var loadingStates: [MainAppSection: Bool] = [
        .genres: false,
        .upcomingMovies: false,
        .recentlySearched: false,
        .discoveredPersons: false,
        .discoveredMovies: false
    ]

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
        setLoading(for: .genres, isLoading: true)
        setLoading(for: .upcomingMovies, isLoading: true)
        interactor.fetchInitialData()

        setLoading(for: .recentlySearched, isLoading: true)
        interactor.fetchRecentlySearchedMovies()
    }

    func didSearch(query: String) {
        // Cancel any previously scheduled search
        searchDebounceWorkItem?.cancel()

        // Wrap search query in a DispatchWorkItem
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            if query.isEmpty {
                self.view?.hideAllElements()
                self.view?.setInitialElements(isHidden: false)
                setLoading(for: .genres, isLoading: true)
                setLoading(for: .upcomingMovies, isLoading: true)
                setLoading(for: .recentlySearched, isLoading: true)
            } else {
                self.view?.setInitialElements(isHidden: true)
                setLoading(for: .discoveredPersons, isLoading: true)
                setLoading(for: .discoveredMovies, isLoading: true)
                setLoading(for: .noResults, isLoading: true)
            }

            self.interactor.performSearch(with: query)
        }
        searchDebounceWorkItem = workItem

        // Schedule the search after 0.84 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.84, execute: workItem)
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map Genre", underlying: nil))

            return
        }

        setLoading(for: .upcomingMovies, isLoading: true)
        interactor.fetchUpcomingMoviesWithGenresFiltering(genre: movieGenre)

        setLoading(for: .recentlySearched, isLoading: true)
        interactor.fetchRecentlySearchedMoviesWithGenresFiltering(genre: movieGenre)
    }

    func didSelectMovie(movieID: Int) {
        // Handle movie selection
        let allMoviesArray = moviesDict.flatMap { $0.value }
        guard let movie = allMoviesArray.first(where: { $0.id == movieID }) else {
            return
        }

        router.navigateToMovieDetails(with: movie)
    }

    func didSelectPerson(personID: Int) {
        // Handle person selection
        router.navigateToPersonDetails(with: personID)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
    }
}

// MARK: - SearchInteractorOutputProtocol
extension SearchPresenter: SearchInteractorOutputProtocol {
    func didFetchGenres(_ genres: [GenreProtocol]) {
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map genres", underlying: nil))

            return
        }

        view?.showGenres(genreViewModels)
        setLoading(for: .genres, isLoading: false)
    }

    func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        guard let upcomingMoviesViewModel = mapper.map(data: movies, to: [MovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map upcoming movies", underlying: nil))

            return
        }

        view?.showUpcomingMovies(upcomingMoviesViewModel)
        self.moviesDict[.upcomingMovies] = movies
        setLoading(for: .upcomingMovies, isLoading: false)
    }

    func didFetchRecentlySearchedMovies(_ movies: [MovieProtocol]) {
        guard let recentlySearchedMoviesViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map recently searched movies", underlying: nil))

            return
        }

        view?.showRecentlySearchedMovies(recentlySearchedMoviesViewModels)
        self.moviesDict[.recentlySearchedMovies] = movies
        setLoading(for: .recentlySearched, isLoading: false)
    }

    func didFetchMoviesSearchResults(_ movies: [MovieProtocol]) {
        guard let searchResultsViewModels = mapper.map(data: movies, to: [MovieListItemViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map movies search results", underlying: nil))

            return
        }

        if searchResultsViewModels.isEmpty, persons.isEmpty {
            view?.showNoResults()
        } else {
            view?.showMoviesSearchResults(searchResultsViewModels)
        }

        self.moviesDict[.searchedMovies(query: "")] = movies

        setLoading(for: .noResults, isLoading: false)
        setLoading(for: .discoveredMovies, isLoading: false)
    }

    func didFetchPersonsSearchResults(_ persons: [PersonProtocol]) {
        guard let personViewModels = mapper.map(data: persons, to: [PersonViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map persons search results", underlying: nil))

            return
        }

        let discoveredMovies = moviesDict[.searchedMovies(query: "")] ?? []
        if personViewModels.isEmpty, discoveredMovies.isEmpty {
            view?.showNoResults()
        } else {
            view?.showPersonsSearchResults(personViewModels)
        }

        self.persons = persons

        setLoading(for: .noResults, isLoading: false)
        setLoading(for: .discoveredPersons, isLoading: false)
    }

    func didFailToFetchData(with error: Error) {
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))

        loadingStates.forEach { setLoading(for: $0.key, isLoading: false) }
    }
}

// MARK: - Private
extension SearchPresenter {
    private func setLoading(for section: MainAppSection, isLoading: Bool) {
        loadingStates[section] = isLoading
        // Notify the view
        view?.setLoadingIndicator(for: section, isVisible: isLoading)
    }
}
