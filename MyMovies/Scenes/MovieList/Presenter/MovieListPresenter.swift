//
//  MovieListPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class MovieListPresenter: MovieListPresenterProtocol {
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorProtocol
    var router: MovieListRouterProtocol

    // MARK: - Init
    init(view: MovieListViewProtocol? = nil, interactor: MovieListInteractorProtocol, router: MovieListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad(listType: MovieListType) {
        interactor.fetchMovieGenres()
        interactor.fetchMovieList(type: listType)
    }
}

// MARK: - MovieListInteractorOutputProtocol
extension MovieListPresenter: MovieListInteractorOutputProtocol {
    func didFetchMovieGenres(_ genres: [GenreProtocol]) {
        view?.showMovieGenres(genres)
    }

    func didFetchMovieList(_ movies: [MovieProtocol]) {
        view?.showMovieList(movies)
    }

    func didFailToFetchData(with error: Error) {
        //
    }
}
