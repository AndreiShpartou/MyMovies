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

    // MARK: - Init
    init(
        view: MainViewProtocol?,
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
    }

    func didSelectMovie(_ movie: MovieProtocol) {
        //
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        guard let movieGenre = mapper.map(data: genre, to: Movie.Genre.self) else {
            return
        }

        interactor.fetchPopularMoviesWithGenresFiltering(genre: movieGenre)
    }

    func didSelectUpcomingMovie(_ movie: MovieProtocol) {
        //
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
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        view?.showError(error: error)
    }
}
