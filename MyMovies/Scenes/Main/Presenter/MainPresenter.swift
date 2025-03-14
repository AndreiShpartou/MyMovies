//
//  MainPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol
    var router: MainRouterProtocol

    private let mapper: DomainModelMapperProtocol
    private var moviesDict: [MovieListType: [MovieProtocol]] = [:]

    // MARK: - Init
    init(
        view: MainViewProtocol? = nil,
        interactor: MainInteractorProtocol,
        router: MainRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - Public
    func viewDidLoad() {
        interactor.fetchMovieGenres()
        interactor.fetchUpcomingMovies()
        interactor.fetchPopularMovies()
        interactor.fetchTopRatedMovies()
        interactor.fetchTheHighestGrossingMovies()
    }

    func didSelectMovie(movieID: Int) {
        let allMoviesArray = moviesDict.flatMap { $0.value }
        guard let movie = allMoviesArray.first(where: { $0.id == movieID }) else {
            return
        }

        router.navigateToMovieDetails(with: movie)
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            return
        }

        interactor.fetchPopularMoviesWithGenresFiltering(genre: movieGenre)
        interactor.fetchTopRatedMoviesWithGenresFiltering(genre: movieGenre)
        interactor.fetchTheHighestGrossingMoviesWithGenresFiltering(genre: movieGenre)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        router.navigateToMovieList(type: listType)
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {

    func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        guard let upcomingMovieViewModels = mapper.map(data: movies, to: [UpcomingMovieViewModel].self) else {
            return
        }
        // Update the view with the fetched data
        view?.showUpcomingMovies(upcomingMovieViewModels)
        moviesDict[.upcomingMovies] = movies
    }

    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        guard let genreViewModels = mapper.map(data: genres, to: [GenreViewModel].self) else {
            return
        }

        view?.showMovieGenres(genreViewModels)
    }

    func didFetchPopularMovies(_ movies: [MovieProtocol]) {
        guard let popularMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showPopularMovies(popularMovieViewModels)
        moviesDict[.popularMovies] = movies
    }

    func didFetchTopRatedMovies(_ movies: [MovieProtocol]) {
        guard let topRatedMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showTopRatedMovies(topRatedMovieViewModels)
        moviesDict[.topRatedMovies] = movies
    }

    func didFetchTheHighestGrossingMovies(_ movies: [MovieProtocol]) {
        guard let theHighestGrossingMovieViewModels = mapper.map(data: movies, to: [BriefMovieListItemViewModel].self) else {
            return
        }

        view?.showTheHighestGrossingMovies(theHighestGrossingMovieViewModels)
        moviesDict[.theHighestGrossingMovies] = movies
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        view?.showError(error: error)
    }
}
