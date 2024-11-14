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
        interactor.fetchRecentlySearchedMovies()
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
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            return
        }

        view?.showGenres(genreViewModels)
        view?.hideLoading()
    }

    func didFetchUpcomingMovie(_ movie: MovieProtocol) {
        guard let upcomingMovieViewModel = mapper.map(data: movie, to: UpcomingMovieViewModel.self) else {
            return
        }

        view?.showUpcomingMovie(upcomingMovieViewModel)
    }

    func didFetchRecentlySearchedMovies(_ movies: [MovieProtocol]) {
        guard let recentlySeachedMoviesViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        if recentlySeachedMoviesViewModels.isEmpty {
            // Fetch popular movies
            interactor.fetchPopularMovies()
        } else {
            view?.showRecentlySearchedMovies(recentlySeachedMoviesViewModels)
        }
    }

    func didFetchPopularMovies(_ movies: [MovieProtocol]) {
        guard let popularMoviesViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showPopularMovies(popularMoviesViewModels)
        view?.hideLoading()
    }

    func didFetchSearchResults(_ movies: [MovieProtocol]) {
        guard let searchResultsViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        if searchResultsViewModels.isEmpty {
            view?.showNoResults()
        } else {
            view?.showSearchResults(searchResultsViewModels)
        }
        view?.hideLoading()
    }

    func didFetchPersonResults(_ persons: [PersonProtocol], relatedMovies: [MovieProtocol]) {
        guard let personViewModels = mapper.map(data: persons, to: [PersonViewModel].self),
              let relatedMoviesViewModels = mapper.map(data: relatedMovies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showPersonResults(personViewModels, relatedMovies: relatedMoviesViewModels)
        view?.hideLoading()
    }

    func didFailToFetchData(with error: Error) {
        view?.hideLoading()
        view?.showError(error: error)
    }
}
