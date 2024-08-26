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

    // MARK: - Init
    init(view: MainViewProtocol?, interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Public
    func viewDidLoad() {
        interactor.fetchUpcomingMovies()
        interactor.fetchMovieGenres()
        interactor.fetchPopularMovies()
    }

    func didSelectMovie(_ movie: MovieProtocol) {
        //
    }

    func didSelectGenre(_ genre: GenreProtocol) {
        //
    }

    func didSelectUpcomingMovies(_ movies: MovieProtocol) {
        //
    }

    func didTapAllPopularMoviesButton() {
        //
    }

    func didTapSeeAllPopularMoviesButton() {
        //
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {

    func didFetchUpcomingMovies(_ movies: [MovieProtocol]) {
        // Update the view with the fetched data
        view?.showUpcomingMovies(movies)
    }

    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        view?.showMovieGenres(genres)
    }

    func didFetchPopularMovies(_ movies: [MovieProtocol]) {
        view?.showPopularMovies(movies)
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        view?.showError(error: error)
    }
}
