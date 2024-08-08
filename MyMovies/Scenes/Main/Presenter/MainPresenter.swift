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
        interactor.fetchMovieLists()
        interactor.fetchMovieCategories()
        interactor.fetchTopMovies()
    }
    
    func didSelectMovie(_ movie: Movie) {
        //
    }

    func didSelectCategory(_ category: Category) {
        //
    }
    
    func didSelectMovieList(_ movieList: MovieList) {
        //
    }

    func didTapAllCategoriesButton() {
        //
    }

    func didTapSeeAllPopularMoviesButton() {
        //
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {

    func didFetchMovieLists(_ movieLists: [MovieList]) {
        // Update the view with the fetched data
        view?.showMovieLists(movieLists: movieLists)
    }

    func didFetchMovieCategories(_ categories: [Category]) {
        view?.showMovieCategories(categories: categories)
    }

    func didFetchTopMovies(_ movies: [Movie]) {
        view?.showPopularMovies(movies: movies)
    }

    func didFailToFetchData(with error: Error) {
        // Handle error
        view?.showError(error: error)
    }
}
